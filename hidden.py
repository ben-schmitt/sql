#this file contains secret user and password info for database connection
# Keep this file separate


def secrets():
    return {"host": "host.com",
            "port": 5432,
            "database": "database",
            "user": "user",
            "pass": "pass"}

def elastic() :
    return {"host": "host.com",
            "prefix" : "elasticsearch",
            "port": 443,
            "scheme": "https",
            "user": "user",
            "pass": "pass"}

def readonly():
    return {"host": "host.com",
            "port": 5432,
            "database": "readonly",
            "user": "readonly",
            "pass": "secret"}

# Return a psycopg2 connection string

# import hidden
# secrets = hidden.readonly()
# sql_string = hidden.psycopg2(hidden.readonly())


def psycopg2(secrets) :
     return ('dbname='+secrets['database']+' user='+secrets['user']+
        ' password='+secrets['pass']+' host='+secrets['host']+
        ' port='+str(secrets['port']))

# Return an SQLAlchemy string


def alchemy(secrets) :
    return ('postgresql://'+secrets['user']+':'+secrets['pass']+'@'+secrets['host']+
        ':'+str(secrets['port'])+'/'+secrets['database'])

