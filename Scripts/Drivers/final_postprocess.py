import sys
import os
import MySQLdb
import urllib
from shutil import copyfile
from warnings import filterwarnings
sys.path.append("Code/PatentsView-DB/Scripts")
from Government_Interest import identify_missed_orgs, merging_cleansed_organization, load_gi
from Inventor_Post import inventor_postprocess
from Assignee_Post import government_assignees
#from Final_Post import process
sys.path.append("To_clone")
from ConfigFiles import config
sys.path.append("Code/PatentsView-DB")
from Location_Disambiguation import get_locs, upload_locs
from multiprocessing import Pool, Process, freeze_support
sys.path.append("Code/PatentsView-DB/Location_Disambiguation")
from googleapi import all_locs, US_locs

#helper function that should be shared
def connect_to_db():
    mydb = MySQLdb.connect(host= config.host,
    user=config.username,
    passwd=config.password,  db =config.merged_database)
    return mydb

# Step 7: Upload Government Interest After Hand Matching
# copy the matched organization lists to the government_manual
print "Have you done the Government Interest manual matching yet?"
done_matching = raw_input("Enter y or n: ") #this allows the user to proceed only if this manual step has been completed
if done_matching == 'y':
	print "OK, running the next government interest step"
	govt_manual = config.folder + "/government_manual"
	processed_gov = config.folder + "/processed_gov"
	merging_cleansed_organization.upload_new_orgs(govt_manual, config.host, config.username, config.password, config.merged_database)
	merging_cleansed_organization.lookup(processed_gov, govt_manual, config.persistent_files)
	load_gi.process(config.host,config.username,config.password,config.merged_database, govt_manual)
run the next steps here too!
else:
	print "OK, skipping the Government Interest upload step for now!"


#Step 8: Run Inventor Post processing file 
print "Have you run the inventor processing algorithm yet?"
#then you need to copy the all-results.txt.post-processed to the disamb_inventor folder from the server
done_matching = raw_input("Enter y or n: ")
if done_matching == 'y':
	print "OK, running inventor post processing"
	clean_inventor = config.folder + "/disamb_inventor"
	inventor_postprocess.inventor_process(clean_inventor)
	csv_to_mysql.upload_csv(config.host,config.username,config.password,config.merged_database,clean_inventor, "/inventor_disambig.csv" , 'inventor')
	csv_to_mysql.upload_csv(config.host,config.username,config.password,config.merged_database,clean_inventor, "/inventor_pairs.csv" , 'patent_inventor')

else:
	print "OK, skipping the Inventor postprocessing for now upload step for now!"


#Step 9: Location Disambiguation
loc_folder = config.folder + "/location_disambiguation/"
get_locs.get(config.folder,config.host, config.username,config.password, config.merged_database, config.incremental_location)
all_locs.locs(loc_folder, config.persistent_files, config.google_api_key)
US_locs.locs(loc_folder, config.persistent_files, config.google_api_key)
upload_locs.upload_locs(loc_folder, config.host, config.username, config.password, config.merged_database)

# #Step 9: Run all the final database preparation steps
process.assignee_type(config.folder,config.host, config.username,config.password, config.merged_database)
process.assignee_locs(config.folder,config.host, config.username,config.password, config.merged_database)


#Step 10: Government exessively long assignee disambiguation
#run the sql script to make table
#hand match
print "Have you handled the exessively long government disambiguated assignees?"
done_matching = raw_input("Enter y or n: ")
if done_matching == 'y':
	assig_folder = folder + "/govt_assignees/"
	print "OK, running government assignee post processing"
	government_assignees.upload_data(connect_to_db(), assig_folder)
	government_assignees.update_rawassignee(connect_to_db())
	#add drop table statements to these






