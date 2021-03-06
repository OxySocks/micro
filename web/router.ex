defmodule Micro.Router do
  use Micro.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Micro do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    
    resources "/products", ProductController do
      resources "/prices", SellingPriceController, except: [:index, :show]
      resources "/barcodes", BarcodeController, except: [:index, :show]
    end

    resources "/categories", CategoryController

  end
end