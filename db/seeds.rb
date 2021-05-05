User.create(username: "Stefano", email: "jesty2002@yahoo.fr", password: "123456..0dA", password_confirmation: "123456..0dA")
User.update_all confirmed_at: DateTime.now