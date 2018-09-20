require 'rubygems'
require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include Roadmap
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    response = self.class.post("/sessions", body: { email: email, password: password })

    @auth_token = response["auth_token"]

    p "email or password is invalid" if @auth_token == nil
  end

  def get_me
    response = self.class.get("/users/me", headers: { "authorization" =>  @auth_token })
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get("/mentors/#{mentor_id}/student_availability", headers: { "authorization" =>  @auth_token })

    JSON.parse(response.body).values.flatten.delete_if { |slot| slot["booked"] == true }
  end
  
end
