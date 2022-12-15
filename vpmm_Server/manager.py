import pill


class PillManager:

    def __init__(self):
        self.pill_list = []

    def add_medicine(self, medicine_name, medicine_qty, before_meal, ):
        self.pill_list.append(medicine_name)

    def view_medicine(self):
        pass

    def update_medicine(self):
        pass

    def delete_medicine(self):
        pass


p = pill.Pill("Percocet", 10, True, 1, 12, False)

