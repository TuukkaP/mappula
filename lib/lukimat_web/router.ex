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
    plug Guardian.Plug.Pipeline, module: LukimatWeb.Guardian,
      error_handler: LukimatWeb.AuthErrorHandlerController
    plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
    plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource, ensure: true
    plug LukimatWeb.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LukimatWeb do
    pipe_through :browser # Use the default browser stack

    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/", LukimatWeb do
    pipe_through [:browser, :authenticated]
    get "/", PageController, :index
    resources "/questions", QuestionController
    resources "/answers", AnswerController
    resources "/schools", SchoolController
    resources "/users", UserController
    resources "/forms", FormController
  end

  # Other scopes may use custom stacks.
  # scope "/api", LukimatWeb do
  #   pipe_through :api
  # end
end
