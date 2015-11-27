require 'spec_helper'
require 'httparty'

describe "Test Suite sends a post request" do
  it "should create a new post in collection" do
    post_request = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: {title: 'pass', due: '1/1/1/1'}
	  expect(post_request.code).to eq 201
    expect(post_request.message == "Created")

    del = HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{post_request["id"]}"
    expect(del.code).to eq 204
    expect(del.message == "No Content")
  end

  it "should fail to make a post without proper arguments" do
    post_request = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: {title: 'fail'}
    expect(post_request.message == "Unprocessable Entity")
  end
end

describe "Test Suite sends a get request" do
  it "should read/get the hash at a specific ID" do
    create = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: {title: 'pass', due: '1/1/1/1'}
    read_id = HTTParty.get "http://lacedeamon.spartaglobal.com/todos/#{create['id']}" 
    expect(read_id["id"] == create['id'])

    del = HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{create['id']}"
    expect(del.message == "NO Content")  
  end

  it "should return all IDs if collection is requested" do
    todos_collection = HTTParty.get 'http://lacedeamon.spartaglobal.com/todos'
    expect(todos_collection.code).to eq 200
    expect(todos_collection.message == 'OK')
  end
end

describe "Test Suite sends a put request" do
  it "should update content of a single todo item from an ID" do
    create = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: {title: 'created new item', due: '1/1/1/1'}
    update = HTTParty.put "http://lacedeamon.spartaglobal.com/todos/#{create['id']}", query: {title: 'updated item title', due: '1/2/4/1'}
    
    expect(update['title'] != create['title'])
    expect(update['due'] != create['due'])

    del = HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{update['id']}"
    expect(del.code).to eq 204
    expect(del.message == "Not Found") 
  end

  it "should get an error trying to send a put request to todos collection" do
    put_request = HTTParty.put "http://lacedeamon.spartaglobal.com/todos/", query: {title: 'updated item title', due: '1/2/4/1'}

    expect(put_request.code).to eq 405
    expect(put_request.message == "Method Not Allowed") 
  end
end

describe "Test Suite sends a patch request" do
  it "should update a field in the item" do
    create = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: {title: 'created new item', due: '1/1/1/1'}
    update = HTTParty.patch "http://lacedeamon.spartaglobal.com/todos/#{create['id']}", query: {title: 'updated item title', due: '1/1/1/1'}

    expect(update['title'] != create['title'])
    
    del = HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{update['id']}"
    expect(del.code).to eq 204
    expect(del.message == "Not Found")
  end

  it "should get an error trying to send a patch request to todos collection" do
    patch_to_collection = HTTParty.patch "http://lacedeamon.spartaglobal.com/todos", query: {title: 'updated item title', due: '1/1/1/1'}
  
    expect(patch_to_collection.code).to eq 405
    expect(patch_to_collection.message == "Method Not Allowed")
  end
end

describe "Test suite sends a delete request" do
  it "should delete a single todo item" do
    create = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: {title: 'created new item', due: '1/1/1/1'}
    
    del = HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{create['id']}"
    expect(del.code).to eq 204
    expect(del.message == "Not Found")
  end
  
  it "should not delete todo collection" do
    del = HTTParty.delete "http://lacedeamon.spartaglobal.com/todos"
    
    expect(del.code).to eq 405
    expect(del.message == "Method Not Allowed")
  end
end