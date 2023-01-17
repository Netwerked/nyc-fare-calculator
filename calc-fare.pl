#! /usr/bin/python3

# Allows us to clear the screen with os.system('clear')
import os
# Allows us to exit the program early with sys.exit()
import sys
# Allows us to round up to the next highest integer with math.ceil()
import math

# Ask and process yes/no questions.
def yn_question(question):
  answer = ""
  question += " (y/n): "
  while answer != "y" and answer != "n" and answer != "yes" and answer != "no":
    answer = input(question).lower()
  answer = answer[0]
  print()
  if answer == "y":
    return True
  else:
    return False
    
# Ask and process numeric questions.
def int_question(question, min, max):
  answer = -1
  question += " ({min} - {max}): ".format(min=min, max=max)
  while True:
    answer = input(question)
    try:
      answer = int(answer)
    except ValueError:
      print ("Please enter a number between {min} and {max}.".format(min=min, max=max))
      continue
    if min <= answer <= max:
      break
  print()
  return answer
 
def print_intro():
  print("This program will determine the best fare options for you to ride the")
  print("New York subway (Metro), as well as local, limited, and Select Bus")
  print("service buses in up to a 30 day period.  I will need to ask you")
  print ("some questions:")
  print("")

def print_thanks():
  print()
  print("Thank you for using this program!")

def check_reduced_fare():
  print("Let's see if you qualify for a 50% reduced fare.")
  reduced_fare_eligible = yn_question("Are you 65 or older, or have a qualifying disability?")

  if reduced_fare_eligible:
    reduced_fare_active = yn_question("Do you have or are you willing to apply for a reduced fare card?")

  if reduced_fare_eligible and reduced_fare_active:
    print("Great! We can take 50% off of your base fares.")
    return True
  else:
    print("You will not receive discounted fares.")
    return False

def check_multi_ride(reduced_base_fare):
  multi_ride = yn_question("Do you plan to ride more than one trip?")

  if multi_ride:
    print("Great, let's gather some more information.")
  else:
    print("Since you only need one ride, we recommend purchasing a single ride card.")
    if reduced_base_fare:
      print("The 50% reduced fare is $1.50.")
    else:
      print("The regular fare is $3.00.")
    print_thanks()
    sys.exit()

def check_metro_card():
  metro_card = yn_question("Do you already have a plastic MetroCard?")

  if metro_card:
    print("Great, then you can reuse your existing card at no extra charge.")
    return 0.00
  else:
    print("You will need to purchase a new card, which adds $1 to the transaction.")
    recommendations.append("Purchase a MetroCard: $1.00")
    return 1.00

def calculate_trips_or_time(days, express, express_trips, trips, total_fare):
  if express:
    # Figure out cost of express service
    if days <= 7:
      recommendations.append("Purchase a 7 day unlimited express bus pass: $62.00")
      total_fare = 62.00
    elif days <= 14:
      recommendations.append("Purchase two 7 day unlimited express bus passes: $124.00")
      total_fare = 124.00
    elif days <= 21:
      recommendations.append("Purchase three 7 day unlimited express bus passes: $186.00")
      total_fare = 186.00
    elif days <= 30:
      recommendations.append("Purchase four 7 day unlimited express bus passes: $248.00")
      total_fare = 248.00

    if not days in [7, 14, 21, 28]:
      recommendations.append("You may need to purchase additional express bus trips for $6.75 each to cover\nweeks where you take less than 10 trips.")

  else:
    # Figure out cost of regular trips
    if days <=7 and trips >= 12:
      recommendations.append("Add 7 day unlimited MetroCard usage: $33.00")
      total_fare = 33.00
    elif days <= 14 and trips >= 24:
      recommendations.append("Add two 7 day unlimited MetroCard usages: $66.00")
      total_fare = 66.00
    elif days <= 21 and trips >= 36:
      recommendations.append("Add three 7 day unlimited MetroCard usages: $99.00")
      total_fare = 99.00
    elif days <= 30 and trips >= 48:
      recommendations.append("Add a 30 day unlimited MetroCard usage: $127.00")
      total_fare = 127.00
    else:
      recommendations.append("Purchase {} individual trips at $2.75 each: ${:.2f}".format(trips, (2.75 * trips)))
      total_fare = 2.75 * trips

  # Add cost of any individual express trips
  if express_trips > 0:
    recommendations.append("Purchase {} individual express bus trips: ${:.2f}".format(express_trips, (6.75 * express_trips)))
    total_fare += 6.75 * express_trips

  return total_fare
  
def calculate_jfk(jfk, total_fare):
  if jfk <= 3:
    recommendations.append("Purchase {} individual JFK AirTrain trips at $8.00 each: ${:.2f}".format(jfk, (8.00 * trips)))
    total_fare = 8.00 * jfk
  elif jfk <= 10:
    recommendations.append("Purchase one JFK AirTrain 10 trip card: $25.00")
    total_fare = 25
  elif jfk == 11:
    recommendations.append("Purchase one JFK AirTrain 10 trip card plus one individual trip: $33.00")
    total_fare = 33
  elif jfk >= 12:
    recommendations.append("Purchase one JFK AirTrain 30 day unlimited trip card: $40.00")
    total_fare = 40
  return total_fare

# Print the final recommendation on what to purchase
def print_recommendations(days, total_fare):
  print("--------------------------------------------------------------------")
  print("Here is what we recommend for you to purchase during your {week} week and {day} day trip:".format(week = int(days / 7), day = days % 7))
  for recommendation in recommendations:
    print(recommendation)
  print()
  if reduced_base_fare:
    print("Total fare is normally: ${:.2f}".format(total_fare))
    print("You qualify for 50% off for a revised total of: ${:.2f}".format(total_fare / 2))
  else:
    print("Total fare is: ${:.2f}".format(total_fare))
  print("--------------------------------------------------------------------")
  print_thanks()

#----Main Program Section-------------------------------------------------

# Define variables
recommendations = []
total_fare = 0.00
days = 0
express_trips = 0
trips = 0

# Clear the screen
os.system('clear')

# Give the end user a program introduction
print_intro()

# Ask the user if they qualify for a reduced fare card
reduced_base_fare = check_reduced_fare()

# Ask the user if they plan to ride more than one trip
check_multi_ride(reduced_base_fare)

# Ask the user if they already have a MetroCard
total_fare += check_metro_card()

# Ask user how many days they will be in NYC
print("Now we need to ask you some questions about your planned riding habits.")
days = int_question("How many days will you be in NYC?  If more than 30, enter 30.", 1, 30)

# Ask user how often they will ride the express bus service in a given week
express = yn_question("Do you plan to ride the Express Bus service more than 9 times a week?")

# If not a frequent express bus user, will they take any express trips?
if not express:
  express_trips = int_question("How many express trips do you plan to take during the {days} days?".format(days=days), 0, (math.ceil(days / 7) * 9))

  # What about regular trips
  trips = int_question("How many non-express trips do you plan to take during the {days} days?".format(days=days), 2, 99)

# Also ask if they plan to use the JFK airport train
jfk = int_question("How many times do you plan to ride to/from JFK?", 0, 99)

# Now calculate the fare, based upon express and regular usage
total_fare += calculate_trips_or_time(days, express, express_trips, trips, total_fare)

# Add JFK airport train fare
total_fare += calculate_jfk(jfk, total_fare)

# Print recommendations to user
print_recommendations(days, total_fare)
