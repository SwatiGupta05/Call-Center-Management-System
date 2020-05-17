import random 
from datetime import datetime
from random import randrange
from datetime import timedelta


def random_date(start, end):
    """
    This function will return a random datetime between two datetime 
    objects.
    """
    delta = end - start
    int_delta = (delta.days * 24 * 60 * 60) + delta.seconds
    random_second = randrange(int_delta)
    return start + timedelta(seconds=random_second)
def pick_unique(l1, l2, l3):
	a = random.choice(l1)
	b = random.choice(l2)
	c = str(a)+"_"+str(b)
	while c in l3:
		a = random.choice(l1)
		b = random.choice(l2)
		c = str(a)+"_"+str(b)
	return a, b
t = 500
f = open("creation_script_revised.sql", "w")

administrator_id = []
problem_category_id = []
solution_id = []
specialization_id = []
specialist_id = []
specialist_specialization_id = []
specialization_problemcategory_id = []
transactions_id = [] 
store_id = []
item_id = []
customer_id = []
operator_id = []
problem_id= []
phonecall_id = []

for c in range(1, 4):
	administrator_id.append(c)
	f.write("INSERT INTO Administrator (administrator_id, user_id, psw, created) VALUES (" + str(administrator_id[-1]) + ", 'administrator_user_" + str(c) + "', 'administrator_psw_" + str(random.randint(0, c)) + "', CURRENT_TIMESTAMP);\n")

for c in range(1, 10):
	problem_category_id.append(c)
	f.write("INSERT INTO ProblemCategory (problem_category_id, administrator_id, description, created) VALUES (" + str(problem_category_id[-1]) + ", " + str(random.choice(administrator_id)) + ", 'description_" + str(c) + "', CURRENT_TIMESTAMP);\n")

for c in range(1, 51):
	solution_id.append(c)
	f.write("INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (" + str(solution_id[-1]) + ", " + str(random.choice(problem_category_id)) + ", 'solution_" + str(c) + "', CURRENT_TIMESTAMP);\n")

for c in range(1, 10):
	specialization_id.append(c)
	f.write("INSERT INTO Specialization (specialization_id, description, created) VALUES (" + str(specialization_id[-1]) + ", 'description_" + str(c) + "', CURRENT_TIMESTAMP);\n")

for c in range(1, 7):
	specialist_id.append(c)
	b = random.choice(specialization_id)
	f.write("INSERT INTO Specialist (specialist_id, name, psw, user_id, created) VALUES (" + str(specialist_id[-1]) + ", 'name_" + str(random.randint(0,c)) + "', 'psw_" + str(random.randint(0,c)) + "', 'user_id_" + str(c) +"', CURRENT_TIMESTAMP);\n")
	f.write("INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (" + str(c) + ", " + str(b) + ", CURRENT_TIMESTAMP);\n")
	specialist_specialization_id.append(str(c)+"_"+str(b))
for c in range(1, 21):
	a, b = pick_unique(specialist_id, specialization_id, specialist_specialization_id)
	specialist_specialization_id.append(str(a)+"_"+str(b))
	f.write("INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (" + str(a) + ", " + str(b) + ", CURRENT_TIMESTAMP);\n")

for c in range(1, 30):
	a, b = pick_unique(specialization_id, problem_category_id, specialization_problemcategory_id)
	specialization_problemcategory_id.append(str(a)+"_"+str(b))
	f.write("INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (" + str(a) + ", " + str(b) + ", CURRENT_TIMESTAMP);\n")

for c in range(1, 15):
	store_id.append(c)
	f.write("INSERT INTO Store (store_id, name, description, created) VALUES (" + str(store_id[-1]) + ", 'name_" + str(c) + "', 'description_" + str(c) + "', CURRENT_TIMESTAMP);\n")
	
for c in range(1, 501):
	transactions_id.append(c)
	d1 = datetime.strptime('1/1/2018 1:00 AM', '%m/%d/%Y %I:%M %p')
	d2 = datetime.strptime('2/20/2018 11:59 PM', '%m/%d/%Y %I:%M %p')
	f.write("INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (" + str(transactions_id[-1]) + ", '" + str(random_date(d1, d2)) + "', '" + random.choice(['PayPal', 'CC', 'DebitCard', 'NetBanking']) + "', CURRENT_TIMESTAMP);\n")
	f.write("INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (" + str(1e5-c) + ", " + str(c) + ", " + str(random.choice(store_id)) + ", " + str(random.randint(0, c)) + ", '" + random.choice(['Electronics', 'Books', 'Home', 'Toys', 'Health']) + "', 'name_" + str(c) + "', 'description_" + str(c) + "', CURRENT_TIMESTAMP);\n")

	
# this is for Table Item
for c in range(1, 1301):
	item_id.append(c)
	f.write("INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (" + str(item_id[-1]) + ", " + str(random.choice(transactions_id)) + ", " + str(random.choice(store_id)) + ", " + str(random.randint(0, c)) + ", '" + random.choice(['Electronics', 'Books', 'Home', 'Toys', 'Health']) + "', 'name_" + str(c) + "', 'description_" + str(c) + "', CURRENT_TIMESTAMP);\n")

	
for c in range(1, 18):
	customer_id.append(c)
	f.write("INSERT INTO Customer (customer_id, name, email, phone, gender, created) VALUES (" + str(customer_id[-1]) + ", 'Customer_name_" + str(c) + "', 'customer_email_" + str(c) + "', 'Customer_phone_" + str(c) + "', '" + str(random.choice(["M", "F"]))+ "', CURRENT_TIMESTAMP);\n")

for c in range(1, 7):
	operator_id.append(c)
	f.write("INSERT INTO Operator ( operator_id, name, psw, user_id, created) VALUES (" + str(operator_id[-1]) + ", 'operator_name_" + str(c) + "', 'operator_psw_" + str(c) + "', 'operator_user_id_" + str(c) + "', CURRENT_TIMESTAMP);\n")

for c in range(1, 51):
	phonecall_id.append(c)
	d1 = datetime.strptime('1/1/2020 1:00 AM', '%m/%d/%Y %I:%M %p')
	d2 = datetime.strptime('2/20/2020 11:59 PM', '%m/%d/%Y %I:%M %p')
	f.write("INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (" + str(phonecall_id[-1]) + ", " + str(random.choice(customer_id)) + ", " + str(random.choice(operator_id)) + ", '" + str(random_date(d1, d2)) + "', " + str(random.randint(5, 600)) + ", CURRENT_TIMESTAMP);\n")
	
for c in range(1, 61):
	problem_id.append(c)
	status = random.choice(['Pending', 'Solved by Specialist', 'Solved by Standard Solution'])
	if status == 'Solved by Specialist' or status == 'Solved by Standard Solution':
		specialist = str(random.choice(specialist_id))
	else:
		specialist = 'NULL'
	#f.write("INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES ("+str(problem_id[-1]) + ", "+ str(random.choice(transactions_id)) + ", " + str(random.choice(phonecall_id)) + ", " + str(random.choice(problem_category_id)) + ", " + str(random.choice(specialist_id)) + ", '"+ random.choice(['Pending', 'Solved by Specialist', 'Solved by Standard Solution']) + "', 'description_" + str(c) + "', CURRENT_TIMESTAMP);\n")
	f.write("INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES ("+str(problem_id[-1]) + ", "+ str(random.choice(transactions_id)) + ", " + str(random.choice(phonecall_id)) + ", " + str(random.choice(problem_category_id)) + ", " + specialist + ", '"+ status + "', 'description_" + str(c) + "', CURRENT_TIMESTAMP);\n")
