User.create(username: "Stefano", email: "admin@mail.com", password: "123456", password_confirmation: "123456")
User.create(username: "John", email: "abonner@mail.com", password: "123456", password_confirmation: "123456")
User.update_all confirmed_at: DateTime.now