# #!/usr/bin/env python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.common.keys import Keys

import logging

logging.basicConfig(format='%(asctime)s %(levelname)-8s %(message)s',level=logging.INFO,datefmt='%Y-%m-%d %H:%M:%S')


# Start the browser and login with standard_user
user = "standard_user"
password = "secret_sauce"
logging.info ('Starting the browser...')
options = ChromeOptions()
options.add_argument("--headless") 
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')
driver = webdriver.Chrome('/usr/bin/chromedriver',options=options)
logging.info ('Browser started successfully. Navigating to the demo page to login.')
driver.get('https://www.saucedemo.com/')
driver.find_element_by_css_selector("input[id='user-name']").send_keys(user)
driver.find_element_by_css_selector("input[id='password']").send_keys(password)
#driver.find_element_by_css_selector("button[id='login-button']").click()
driver.find_element_by_css_selector('input[type="submit"]').click()

logging.info (driver.current_url)

backpack = driver.find_element_by_css_selector("button[id='add-to-cart-sauce-labs-backpack']").click()

logging.info ("selected backpack")

bikelight = driver.find_element_by_css_selector("button[id='add-to-cart-sauce-labs-bike-light']").click()

logging.info ("selected bikelight")

tshirt = driver.find_element_by_css_selector("button[id='add-to-cart-sauce-labs-bolt-t-shirt']").click()

logging.info ("selected t-shirt")

fleecejacket = driver.find_element_by_css_selector("button[id='add-to-cart-sauce-labs-fleece-jacket']").click()

logging.info ("selected fleecejacket")

onesie = driver.find_element_by_css_selector("button[id='add-to-cart-sauce-labs-onesie']").click()

logging.info ("selected onesie")

allthethings = driver.find_element_by_css_selector("button[id='add-to-cart-test.allthethings\(\)-t-shirt-\(red\)']").click()

logging.info ("selected allthethings t-shirt")

#driver.save_screenshot('selected.png')

shoppingcart = driver.find_element_by_css_selector("div[id='shopping_cart_container'] > a.shopping_cart_link").click()

logging.info ("selected shopping cart")

#driver.save_screenshot('shoppingcart.png')

logging.info (driver.current_url)

xbackpack = driver.find_element_by_css_selector("button[id='remove-sauce-labs-backpack']").click()

logging.info ("removed backpack from shopping cart")

xbikelight = driver.find_element_by_css_selector("button[id='remove-sauce-labs-bike-light']").click()

logging.info ("removed bikelight from shopping cart")

xtshirt = driver.find_element_by_css_selector("button[id='remove-sauce-labs-bolt-t-shirt']").click()

logging.info ("removed t-shirt from shopping cart")

xfleecejacket = driver.find_element_by_css_selector("button[id='remove-sauce-labs-fleece-jacket']").click()

logging.info ("removed fleecejacket from shopping cart")

xonesie = driver.find_element_by_css_selector("button[id='remove-sauce-labs-onesie']").click()

logging.info ("removed onesie from shopping cart")

xallthethings = driver.find_element_by_css_selector("button[id='remove-test.allthethings\(\)-t-shirt-\(red\)']").click()

logging.info ("removed allthethings t-shirt from shopping cart")

#driver.save_screenshot('shoppingcart2.png')
