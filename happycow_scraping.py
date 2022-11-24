import pandas as pd
from selenium import webdriver
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.common.by import By

# setting selenium options
options = Options()
options.headless = True # keep selenium from opening browser window
driver = webdriver.Firefox(executable_path='C:/Users/Noah/AppData/Local/Programs/Python/Python310/geckodriver.exe', options=options)

url = 'https://www.happycow.net/north_america/usa/'

# box of states xpath:
# /html/body/div[1]/div[1]/div[2]/div[2]/div/div/div[2]/div[3]/div/div

driver.get(url)
assert 'Vegan' in driver.title

num_of_restaurants = []
states = []

for i in range(61): # looping through every div containing the number of restaurants
                    # in a given state
                    # (there are more than 50 divs)
    num_xpath = f'/html/body/div[1]/div[1]/div[2]/div[2]/div/div/div[2]/div[3]/div/div/div[{i+1}]/a/div/div[2]'
    state_xpath = f'/html/body/div[1]/div[1]/div[2]/div[2]/div/div/div[2]/div[3]/div/div/div[{i+1}]/a/div/div[1]'
    num = (driver.find_element(By.XPATH, num_xpath)).text
    state = (driver.find_element(By.XPATH, state_xpath)).text
    
    if num: # if the div doesn't return empty values
        num_of_restaurants.append(int(num[1:-1]))
    if state:
        states.append(state)

per_state = pd.DataFrame([], dtype='int64')

per_state['state'] = states
per_state['num_of_restaurants'] = num_of_restaurants

per_state.to_excel('veggie_restaurants_per_state.xlsx', index=False, header=True)

driver.close()