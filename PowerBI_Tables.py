from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import pandas as pd

driver = webdriver.Chrome()

driver.get("https://app.powerbi.com/view?r=eyJrIjoiOGI5Yzg2MGYtZmNkNy00ZjA5LTlhYTYtZTJjNjg2NTY2YTlmIiwidCI6ImI1NDE0YTdiLTcwYTYtNGUyYi05Yzc0LTM1Yjk0MDkyMjk3MCJ9")

def scrape_powerbi_table(visual_container_number):
    table_xpath = "//*[@id='pvExplorationHost']/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[" + str(visual_container_number) + "]/transform/div/div[3]/div/visual-modern"
    scroll_button = WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.XPATH, table_xpath + "/div/div/div[2]/div[4]/div[2]")))
    col_names = [i.text for i in driver.find_elements(By.XPATH, table_xpath + "/div/div/div[2]/div[1]/div[2]/div[2]/div/div")]
    df = pd.DataFrame(columns = col_names)
    more_rows_left = True
    row_count = 2
    while more_rows_left == True:
        data = driver.find_elements(By.XPATH, table_xpath + "/div/div/div[2]/div[1]/div[4]/div/div[@aria-rowindex='" + str(row_count) + "']/div")
        current_row = [i.get_attribute("innerHTML") for i in data][1:]
        if not current_row:
            try:
                for i in range(10):
                    scroll_button.click()
                data = driver.find_elements(By.XPATH, table_xpath + "/div/div/div[2]/div[1]/div[4]/div/div[@aria-rowindex='" + str(row_count) + "']/div")
                current_row = [i.get_attribute("innerHTML") for i in data][1:]
            except Exception:
                break
        if not current_row:
            break
        df.loc[len(df)] = current_row
        row_count += 1
    return df

next_button = WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.XPATH, "//*[@id='embedWrapperID']/div[2]/logo-bar/div/div/div/logo-bar-navigation/span/button[2]")))

df1 = scrape_powerbi_table(8)
next_button.click()
df2 = scrape_powerbi_table(8)
df3 = scrape_powerbi_table(9)
next_button.click()
next_button.click()
df4 = scrape_powerbi_table(5)
df5 = scrape_powerbi_table(7)
next_button.click()
df6 = scrape_powerbi_table(9)
df7 = scrape_powerbi_table(10)
next_button.click()
next_button.click()
df8 = scrape_powerbi_table(2)
next_button.click()
df9 = scrape_powerbi_table(5)
df10 = scrape_powerbi_table(6)

driver.quit()