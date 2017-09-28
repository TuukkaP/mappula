defmodule LukimatWeb.Router do
  use LukimatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authenticated do
    plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource, ensure: true
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :guardian do
    plug Guardian.Plug.Pipeline, module: LukimatWeb.Guardian,
      error_handler: LukimatWeb.AuthErrorHandlerController
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource, allow_blank: true
    plug LukimatWeb.CurrentUser
  end

  scope "/", LukimatWeb do
    pipe_through [:browser, :guardian]

    resources "/sessions", SessionController, only: [:new, :create]
    get "/register", UserController, :new, as: :register
    post "/users", UserController, :create
  end

  scope "/", LukimatWeb do
    pipe_through [:browser, :guardian, :authenticated]
    get "/", PageController, :index
    resources "/sessions", SessionController, only: [:delete]
    resources "/questions", QuestionController
    resources "/answers", AnswerController
    resources "/schools", SchoolController
    resources "/users", UserController
    resources "/choices", ChoiceController
    resources "/forms", FormController
    resources "/fill", FillFormController, only: [:index]
    resources "/forms/:form_id/fill", FillFormController, only: [:new, :create]
  end

  scope "/api", LukimatWeb do
    pipe_through [:api, :guardian, :authenticated]
    resources "/forms", Api.FormController, only: [:show]
    resources "/forms/:form_id/questions", Api.QuestionController, only: [:index]
  end
end
