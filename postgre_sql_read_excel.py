from sqlalchemy import create_engine
import pandas as pd
import boto3

engine = create_engine('postgresql://postgres:LAHsiv#31@localhost:5432/SAMPLE')

file = 'C:/Users/vs786/OneDrive/Desktop/orders.csv'

df = pd.read_csv(file)

df.to_sql('orders', engine)
# install these first--- pandas, boto3, sqlalchemy,psycopg2