require 'rails_helper'

RSpec.describe TodosController, type: :controller do
  let(:todos) {
    [
      { 'description' => 'task 1' },
      { 'description' => 'task 2' },
    ]
  }
  describe '#index' do
    it 'returns todos' do
      session[:todos] = todos
      get :index
      expect(JSON.parse(response.body)).to eq(todos)
    end
  end
  describe '#create' do
    it 'stores todos' do
      post :create, { todos: todos }
      expect(session[:todos]).to eq(todos)
    end
  end
end
