import pandas as pd
# import sklearn.externals
import joblib
import time


class MlModelLoader:
    def __init__(self, selected_model_name, inputted_list):
        self.final_dict = []
        self.model_inp_list = []  # user inputs converted to binary is stored here and passed into the model predictor
        self.answer_list = []  # user inputs stored as a percentage to get the final probability
        self.selected_model_name = selected_model_name
        self.inputted_list = inputted_list

    def run_model(self):
        if self.selected_model_name == "covid":
            model_name = "covid_model.h5"
            self.__load_covid(model_name)
            return self.final_dict

        elif self.selected_model_name == "monkeypox":
            model_name = "monkeypox_model.h5"
            self.__load_monkeypox(model_name)
            return self.final_dict

    def __load_covid(self, model_name):
        for i in self.inputted_list:
            if type(i) == int:
                self.model_inp_list, self.answer_list = self.__one_ten_ans(i, self.model_inp_list, self.answer_list)
            else:
                self.model_inp_list, self.answer_list = self.__y_n_ans(i, self.model_inp_list, self.answer_list)

        self.final_dict = self.__create_dict(self.answer_list, model_name, self.model_inp_list)

    def __load_monkeypox(self, model_name):
        for i in self.inputted_list:
            if type(i) == list:
                self.model_inp_list, self.answer_list = self.__illness_ans(i[0], self.model_inp_list, self.answer_list)
            elif type(i) == int:
                self.model_inp_list, self.answer_list = self.__one_ten_ans(i, self.model_inp_list, self.answer_list)
            else:
                self.model_inp_list, self.answer_list = self.__y_n_ans(i, self.model_inp_list, self.answer_list)

        self.final_dict = self.__create_dict(self.answer_list, model_name, self.model_inp_list)

    # 0 to 10 user input validator function
    def __one_ten_ans(self, input, model_inp_list, answer_list):
        inp = input * 10
        answer_list.append(inp)
        if input >= 5:
            model_inp_list.append(1)
        else:
            model_inp_list.append(0)
        return model_inp_list, answer_list

    # yes / no user input weighting function
    def __y_n_ans(self, input, model_inp_list, answer_list):
        if input:
            model_inp_list.append(1)
            answer_list.append(100)
        elif not input:
            model_inp_list.append(0)
            answer_list.append(0)
        else:
            print("error")
            exit(1)
        return model_inp_list, answer_list

    # 4 types of illness weighting function
    def __illness_ans(self, input, model_inp_list, answer_list):
        if input == 0:
            model_inp_list.append(0)
            answer_list.append(25)
        elif input == 1:
            model_inp_list.append(1)
            answer_list.append(50)
        elif input == 2:
            model_inp_list.append(2)
            answer_list.append(75)
        elif input == 3:
            model_inp_list.append(3)
            answer_list.append(100)
        return model_inp_list, answer_list

    def __create_dict(self, answer_list, model_name, model_inp_list):
        risk_probability = self.__probab_calc2(answer_list, model_name, model_inp_list)
        model_prediction = self.__predict_inputs(model_inp_list, model_name)

        model_output = {
            "model_prediction": model_prediction[0],
            "risk_probability": risk_probability
        }

        return model_output

    # calculates the probability from the weigted user inputs
    def __probab_calc2(self, input_list, model_name, model_inp_list):
        list_elems = len(input_list)  # number of questions in the model (# of inputs)
        inp_sum = sum(input_list)  # sumation of all the values in the input list eg [70 + 30 + 20 + 50] = 170
        risk = ""
        probability = (inp_sum / list_elems)  # probability = sum of weights / number of questions  --- eg: 170/4
        if self.__predict_inputs(model_inp_list, model_name) == 0:
            return risk
        else:
            if (probability >= 70) and (probability <= 100):
                print("Risk : High")
                risk = "High"

            elif (probability >= 40) and (probability < 70):
                print("Risk : Medium")
                risk = "Medium"

            elif (probability >= 0) and (probability < 40):
                print("Risk : Low")
                risk = "Low"

            else:
                print("Error")
                exit(1)

        # print("Probability is: " + str(probability) + "% ")
        return risk

    # loads the model using joblib
    def __load_model(self, model_name):
        try:
            model = joblib.load(model_name)
            print("Model Loaded!")
            return model
        except:
            print("Error loading the model")

    def __predict_inputs(self, input_list, model_name):
        # needs to be a 2D array
        st = time.time()
        # try:
        model = self.__load_model(model_name)
        model_output = model.predict([input_list])  # predicts the model_inp_list passed to this function
        et = time.time() - st
        # model_output_prob = model.predict_proba([input_list])
        # print ("Chance of having covid is  : " + str(model_output ) )
        print(" Time : {:.2f} s".format(et))  # time taken for the .predictor method to output a result
        return model_output
        # except:
        # print("Error occured when finding the model file!")


