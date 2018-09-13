local iucConf = require('IUCConfigsTest1')
local mapDB = {}

function mapDB.init() 
	local conn = db.connect{api=db.SQLITE,
      name = iucConf.patientDbPath..iucConf.patientDbFile}
   return conn
end

function mapDB.createTable(conn) 
	local sql = [[CREATE TABLE 'PatientData'
                      ('PatientId' INTEGER, 
                       'sex' TEXT,
                       'FirstName' TEXT,
                       'LastName'  TEXT,
                       'DateOfBirth'  TEXT,
                       'SSN' INTEGER,
                        PRIMARY KEY(PatientId));]]
   conn:execute{sql=sql,live=true}
   return sql
end

function mapDB.checkTable(conn) 
   local sql = [[SELECT name FROM sqlite_master WHERE type='table' AND name='PatientData']]
   local result = conn:query{sql=sql,live=true}
   return not result[1]:isNull()
end


function mapDB.insert(jsonTbl,conn) 
   local exists = mapDB.checkTable(conn)
   
   if not exists then mapDB.createTable(conn) end
   
   local sqlStm = [[INSERT OR REPLACE INTO PatientData VALUES (']]..
      jsonTbl['patientId'].."','" ..jsonTbl['sex'].."','"..jsonTbl['firstName']..
      "','"..jsonTbl['lastName'].."','"..jsonTbl['dob'].."','"..jsonTbl['ssn'].."')"
      
   conn:execute{sql=sqlStm,live=true}
end

return mapDB