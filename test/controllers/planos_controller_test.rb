require 'test_helper'

class PlanosControllerTest < ActionController::TestCase
  setup do
    @plano = planos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:planos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create plano" do
    assert_difference('Plano.count') do
      post :create, plano: { nome: @plano.nome, preco: @plano.preco }
    end

    assert_redirected_to plano_path(assigns(:plano))
  end

  test "should show plano" do
    get :show, id: @plano
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @plano
    assert_response :success
  end

  test "should update plano" do
    patch :update, id: @plano, plano: { nome: @plano.nome, preco: @plano.preco }
    assert_redirected_to plano_path(assigns(:plano))
  end

  test "should destroy plano" do
    assert_difference('Plano.count', -1) do
      delete :destroy, id: @plano
    end

    assert_redirected_to planos_path
  end
end
