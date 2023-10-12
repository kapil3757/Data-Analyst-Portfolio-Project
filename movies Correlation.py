#!/usr/bin/env python
# coding: utf-8

# In[ ]:


# Import Libraries---


# In[2]:


import pandas as pd
import seaborn as sns
import numpy as np

import matplotlib
import matplotlib.pyplot as plt

plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize']=[12,8] # Adjust the configuration of the plotswe will create

# Read in the data

df=pd.read_csv(r'/Users/kapilchaudhary/Downloads/movies.csv')


# In[3]:


#let's look out the data
df.head()


# In[4]:


# lets see if there is any missing data


for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col, pct_missing))


# In[5]:


# Data Types for our columns
df.dtypes


# In[6]:


# Filling the Null values in table

df=df.fillna(method='ffill')



# In[7]:


df.head()



# In[9]:


#change datatype of the columns

df['budget'] = df['budget'].astype('int64')
df['gross'] = df['gross'].astype('int64')


# In[8]:


df.head()


# In[35]:


df=df.sort_values(by=['gross'], inplace=False, ascending=False)


# In[ ]:





# In[9]:


#drop any duplicates------


df.drop_duplicates()
df.head()


# In[ ]:


# Budget High correlation
#company high correlation


# In[15]:


#scatter plot with budget vs gross


plt.scatter(x=df['budget'],y=df['gross'])
plt.title('Budget vs Gross Earnings')
plt.xlabel('Gross earnings')
plt.ylabel('Budget for film')
plt.show()


# In[16]:


df.head()


# In[17]:


# plot budget vs gross using seaborn

sns.regplot(x='budget',y='gross', data=df, scatter_kws={'color':'red'},line_kws={'color':'blue'})


# In[18]:


# Delete a column in our data base
df.drop(['released'],axis=1,inplace=True)


# In[38]:


# let's looking for a correlation



# In[26]:


df.corr(method='pearson') #pearson, kendall,spearman


# In[ ]:


# High correaltion Budget and gross


# In[39]:


correlation_matrix = df.corr(method='pearson')

sns.heatmap(correlation_matrix, annot=True)
plt.title('Correlation Matrix for Numeric Features')
plt.xlabel('Movie Features')
plt.ylabel('Movie Features')
plt.show()


# In[ ]:




