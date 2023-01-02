import pandas as pd
#import sklearn.externals
import joblib
import time

# prompts the columns of datasets as questions
def question_ans(file_name):
  answer_list = []
  a = 0
  file = pd.read_csv(file_name)
  questions = list(file.columns)
  question_num = len(file.columns) - 1
  print ("# questions" + str(question_num))
  for i in questions:
      a += 1
      if(a <= question_num):
        answer = int(input (str(a) + ". Do you have "  + i + " [yes: 1 | no: 0] :  "))
        answer_list.append(answer)
  return list(answer_list)

def questions_covid():
  model_inp_list = []
  answer_list = []

  q1 = int(input("1. Do you have breathing problems how severe is it (0 - 10) : "))
  model_inp_list, answer_list = one_ten_ans(q1, model_inp_list, answer_list)
  q2 = int(input("2. Do you have fever how severe is i (0 - 10) : "))
  model_inp_list, answer_list = one_ten_ans(q2, model_inp_list, answer_list)
  q3 = int(input("3. Do you have dry cough how severe is it (0 - 10): "))
  model_inp_list, answer_list = one_ten_ans(q3, model_inp_list, answer_list)
  q4 = int(input("4. Do you have a sore throat how severe is it (0 - 10): "))
  model_inp_list, answer_list = one_ten_ans(q4, model_inp_list, answer_list)
  q5 = int(input("5. Do you have running nose how severe is it (0 - 10): "))
  model_inp_list, answer_list = one_ten_ans(q5, model_inp_list, answer_list)
  q6 = input("6. Do you have asthma (yes|no): ")
  model_inp_list, answer_list = y_n_ans(q6, model_inp_list, answer_list)
  q7 = input("7. Do you have chronic lung diseases (yes|no): ")
  model_inp_list, answer_list = y_n_ans(q7, model_inp_list, answer_list)
  q8 = int(input("8. Do you have headache how severe is it (0 - 10): "))
  model_inp_list, answer_list = one_ten_ans(q8, model_inp_list, answer_list)
  q9 = input("9. Do you have any heart diseases (yes|no): ")
  model_inp_list, answer_list = y_n_ans(q9, model_inp_list, answer_list)
  q10 = input("10. Do you have diabetes (yes|no): ")
  model_inp_list, answer_list = y_n_ans(q10, model_inp_list, answer_list)
  q11 = input("11. Do you have hyper tension how severe is it (yes|no): ")
  model_inp_list, answer_list = y_n_ans(q11, model_inp_list, answer_list)
  q12 = int(input("12. Do you have fatigue how severe is it (0 - 10): "))
  model_inp_list, answer_list = one_ten_ans(q12, model_inp_list, answer_list)
  q13 = input("13. Do you have gastrointestinal how severe is it (yes|no): ")
  model_inp_list, answer_list = y_n_ans(q13, model_inp_list, answer_list)
  q14 = input("14. Did you travel abroad recently (yes|no) : ")
  model_inp_list, answer_list = y_n_ans(q14, model_inp_list, answer_list)
  q15 = input("15. Did you get in contact with a covid patient recently (yes|no): ")
  model_inp_list, answer_list = y_n_ans(q15, model_inp_list, answer_list)
  q16 = input("16. Did you attended any large gatherings recently (yes|no): ")
  model_inp_list, answer_list = y_n_ans(q16, model_inp_list, answer_list)
  q17 = input("17. Did you visit any public exposed places recently (yes|no): ")
  model_inp_list, answer_list = y_n_ans(q17, model_inp_list, answer_list)
  q18 = input("18. Do any of your family members working in public exposed places (yes|no): ")
  model_inp_list, answer_list = y_n_ans(q18, model_inp_list, answer_list)
  q19 = input("19. Did you wear masks when meeting outsiders (yes|no): ")
  model_inp_list, answer_list = y_n_ans(q19, model_inp_list, answer_list)
  q20 = input("20. Did you use sanitization from the market (yes|no): ")
  model_inp_list, answer_list = y_n_ans(q20, model_inp_list, answer_list)


  print("model input: " + str(model_inp_list))
  print("answer list is: " + str(answer_list) )
  
  probab_calc(answer_list)

  return model_inp_list


def questions_monkeypox():
  model_inp_list = []
  answer_list = []

  q1 = input("1. What is the systemic illness (none|fever|swollen lymph nodes|muscle aches and pain): ")
  model_inp_list, answer_list = illness_ans(q1, model_inp_list, answer_list)
  q2 = input("1. Do you have rectal pain (yes|no): ")
  model_inp_list, answer_list = y_n_ans(q2, model_inp_list, answer_list)
  q3 = int(input("2. Do you have sore throat how severe is it (0 - 10) : "))
  model_inp_list, answer_list = one_ten_ans(q3, model_inp_list, answer_list)
  q4 = input("3. Do you have Penile Oedema (yes|no): ")
  model_inp_list, answer_list = y_n_ans(q4, model_inp_list, answer_list)
  q5 = input("4. Do you have oral lesions (yes|no): ")
  model_inp_list, answer_list = y_n_ans(q5, model_inp_list, answer_list)
  q6 = input("5. Do you have solitary lesions (yes|no): ")
  model_inp_list, answer_list = y_n_ans(q6, model_inp_list, answer_list)
  q7 = input("6. Do you have swollen tonsils (yes|no): ")
  model_inp_list, answer_list = y_n_ans(q7, model_inp_list, answer_list)
  q8 = input("7. Do you have HIV infection (yes|no): ")
  model_inp_list, answer_list = y_n_ans(q8, model_inp_list, answer_list)
  q9 = input("8. Do you sexually transmitted infection (yes|no): ")
  model_inp_list, answer_list = y_n_ans(q9, model_inp_list, answer_list)

  print("model input: " + str(model_inp_list))
  print("answer list is: " + str(answer_list) )
  
  probab_calc(answer_list)


  return model_inp_list


def one_ten_ans(input, model_inp_list, answer_list):
  inp = input * 10
  answer_list.append(inp)
  if (input >= 5):
    model_inp_list.append(1)
  else:
    model_inp_list.append(0)
  return model_inp_list, answer_list


def y_n_ans(input, model_inp_list, answer_list):
  if input == "yes":
    model_inp_list.append(1)
    answer_list.append(100)
  elif input == "no":
    model_inp_list.append(0)
    answer_list.append(0)
  else: 
    print("error")
    exit(1)
  return model_inp_list, answer_list



def temp_ans(input, model_inp_list, answer_list):
  inp = (input/109.4) * 100 
  answer_list.append(inp)
  if (input >= 100.4):
    model_inp_list.append(1)
  else:
    model_inp_list.append(0)

  return model_inp_list, answer_list

def illness_ans(input, model_inp_list, answer_list):
  if input == "none":
    model_inp_list.append(0)
    answer_list.append(25)
  elif input == "fever":
    model_inp_list.append(1)
    answer_list.append(50)
  elif input == "swollen lymph node":
    model_inp_list.append(2)
    answer_list.append(75)
  elif input == "muscle aches and pain":
    model_inp_list.append(3)
    answer_list.append(100)
  return model_inp_list, answer_list


#def hypertenion_ans(input, answer_list, model_inp_list):
#  inp = (input/200) * 100 
#  answer_list.append(inp)  
#  if (input >= 120):
#    model_inp_list.append(1)
#  else:
#    model_inp_list.append(0)

  #---------------------------------------------------

def probab_calc(input_list):
  list_elems = len(input_list)
  inp_sum = sum(input_list)

  probability = (inp_sum/list_elems)

  print("Probability is: " + str(probability) + "% ")
  return



#loads the model using joblib
def load_model(model_name):
  try:
    model = joblib.load(model_name)
    print("Model Loaded!")
    return model
  except:
    print("Error loading the model")


def predict_inputs(input_list, model_name):
  # needs to be a 2D array
  st = time.time()
  #try:
  model = load_model(model_name)
  model_output = model.predict([input_list])
  et =  time.time() - st
    #model_output_prob = model.predict_proba([input_list])
  print ("Chance of having covid is  : " + str(model_output ) )
  print (" Time : {:.2f} s".format(et))

  #except:
   # print("Error occured when finding the model file!")


def main():

    tester = input("Which Model: (covid | monkeypox) : ")

    if tester == "covid":
      model_name = "covid_model.h5"

      ans_list = questions_covid()
      predict_inputs(ans_list, model_name)
    
    elif tester == "monkeypox":
      model_name = "monkeypox_model.h5"

      ans_list = questions_monkeypox()
      predict_inputs(ans_list, model_name)



    print("END!")
    

if __name__ == "__main__":
    main()



