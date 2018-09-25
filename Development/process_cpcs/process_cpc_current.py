import sys
import os
import MySQLdb
sys.path.append('{}/{}'.format(os.getcwd(), 'Development'))
from helpers import general_helpers
from warnings import filterwarnings
import csv
import re,os,random,string,codecs
import multiprocessing



def get_patent_ids(db_con, new_db):

    patent_data = db_con.execute('select id, number from {}.patent'.format(new_db))
    patnums = {}
    for patent in patent_data:
        patnums[patent['number']] = patent['id']
    return set(patnums.keys()), patnums


def write_cpc_current(cpc_input, cpc_output, error_log, patent_dict, patent_set,db_con):
    
    #Create CPC_current table off full master classification list
    cpc_data= csv.reader(open(cpc_input,'r'),delimiter = ',')
    errorlog = csv.writer(open(error_log, 'w'))
    current_exist = {}
    cpc_out = csv.writer(open(cpc_output,'w'),delimiter = '\t')
    for row in cpc_data:
        if str(row[0]) in patent_set:
            towrite = [re.sub('"',"'",item) for item in row[:3]]
            towrite.insert(0,general_helpers.id_generator())
            towrite[1] = patent_dict[row[0]]
            for t in range(len(towrite)):
                try:
                    gg = int(towrite[t])
                    towrite[t] = str(int(towrite[t]))
                except:
                    pass
            primaries = towrite[2].split("; ")
            cpcnum = 0
            for p in primaries:
                try:
                    needed = [general_helpers.id_generator(),towrite[1]]+[p[0],p[:3],p[:4],p,'primary',str(cpcnum)]
                    clean = [i if not i =="NULL" else "" for i in needed]
                    cpcnum+=1
                    cpc_out.writerow(clean)
                except: #sometimes a row doesn't have all the information
                    errorlog.writerow(row)

            additionals = [t for t in towrite[3].split('; ') if t!= '']
            for p in additionals:
                try:
                    needed = [id_generator(),towrite[1]]+[p[0],p[:3],p[:4],p,'additional',str(cpcnum)]
                    clean = [i if not i =="NULL" else "" for i in needed]
                    cpcnum+=1
                    cpc_out.writerow(clean)
                except:
                    errorloc.writerow(row)
    errorlog.close()


def upload_cpc_current(db_con, cpc_current_loc):
    cpc_current_files = [f for file in os.listdir(cpc_current_loc) if f.startswith('out')]
    for outfile in cpc_current_files:
    	data = pd.read_csv('{}/{}'.format(cpc_current_loc,outfile),delimiter = '\t', encoding ='utf-8')
    	data.to_sql(cpc_current, db_con, if_exists = 'append', index=False)


if __name__ == '__main__':
    import configparser
    config = configparser.ConfigParser()
    config.read('Development/config.ini')

    db_con = general_helpers.connect_to_db(config['DATABASE']['HOST'], config['DATABASE']['USERNAME'], 
                                            config['DATABASE']['PASSWORD'], config['DATABASE']['NEW_DB'])

    
    patent_set, patent_dict = get_patent_ids(db_con, config['DATABASE']['NEW_DB'])

    cpc_folder = '{}/{}'.format(config['FOLDERS']['WORKING_FOLDER'],'cpc_output')
    #split up the grant file for processing
    os.system('split -a 1 -n 7 {0}/grants_classes.csv {0}/grants_pieces_'.format(cpc_folder))

    in_files = ['{0}/grants_pieces_{1}'.format(cpc_folder, item) for item in  ['a', 'b', 'c', 'd', 'e', 'f', 'g']]
    out_files = ['{0}/out_file_a{1}.csv'.format(cpc_folder, item) for item in  ['a', 'b', 'c', 'd', 'e', 'f', 'g']]
    error_log = ['{0}/error_log_a{1}'.format(cpc_folder, item) for item in  ['a', 'b', 'c', 'd', 'e', 'f', 'g']]
    pat_dicts = [patent_dict for item in in_files]
    pat_sets = [patent_set for item in in_files]
    files = zip(in_files, out_files, error_log, pat_dicts, pat_sets)
    

    print("Processing Files")
    desired_processes = 7 # ussually num cpu - 1
    jobs = []
    for f in files:
        jobs.append(multiprocessing.Process(target = write_cpc_current, args=(f)))

    for segment in general_helpers.chunks(jobs, desired_processes):
        print(segment)
        for job in segment:
            job.start()

    #os.system('cat {0}/out_file* > {0}/cpc_current.csv'.format(cpc_folder))
    upload_cpc_current(db_con, cpc_folder))