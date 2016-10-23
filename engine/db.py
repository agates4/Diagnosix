import sys, ConfigParser
import MySQLdb as mdb
from plaid.utils import json
from datetime import datetime, timedelta
import math
import uuid
import hashlib
import json
from find_words import get_data
import random

class SQLConnection:
    """Used to connect to a SQL database and send queries to it"""
    config_file = 'db.cfg'
    section_name = 'Database Details'

    _db_name = ''
    _hostname = ''
    _username = ''
    _password = ''

    def __init__(self):
        config = ConfigParser.RawConfigParser()
        config.read(self.config_file)
        print "making"

        try:
            _db_name = config.get(self.section_name, 'db_name')
            _hostname = config.get(self.section_name, 'hostname')
            _user = config.get(self.section_name, 'user')
            _password = config.get(self.section_name, 'password')
        except ConfigParser.NoOptionError as e:
            print ('one of the options in the config file has no value\n{0}: ' +
                '{1}').format(e.errno, e.strerror)
            sys.exit()


        self.con = mdb.connect(_hostname, _user, _password, _db_name)
        self.con.autocommit(False)
        self.con.ping(True)

        self.cur = self.con.cursor(mdb.cursors.DictCursor)

    ##############START CALLED ONLY IN SQL FILE###############
    def query(self, sql_query, values=None):
            """
            take in 1 or more query strings and perform a transaction
            @param sql_query: either a single string or an array of strings
                representing individual queries
            @param values: either a single json object or an array of json objects
                representing quoted values to insert into the relative query
                (values and sql_query indexes must line up)
            """
            #  TODO check sql_query and values to see if they are lists
            #  if sql_query is a string
            if isinstance(sql_query, basestring):   
                self.cur.execute(sql_query, values)
                self.con.commit()
            #  otherwise sql_query should be a list of strings
            else:
                #  execute each query with relative values
                for query, sub_values in zip(sql_query, values):
                    self.cur.execute(query, sub_values)
                #  commit all these queries
                self.con.commit()
            return self.cur.fetchall()
    def close(self):
        self.cur.close()

    def get_data(self):
        return json.dumps(self.query("SELECT * FROM appointments"))

    def send_data(self,conversation):
        data=get_data().send_json(conversation)
        
        print type(data)
        junk= json.loads(data)
        print junk["ID"] 

        #fuck=int(json.loads(data))
        #print fuck
        #print data["ID"]
        random_num=random.randrange(106, 500000)
        self.query("INSERT INTO appointments VALUES (%s,%s,%s,%s,%s);",(random_num,junk["ID"],junk["Name"],junk["Date"],"700 Huron Rd E, Cleveland"))


#SQLConnection().send_data("abortion is bad")