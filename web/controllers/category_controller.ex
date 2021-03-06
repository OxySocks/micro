defmodule Micro.CategoryController do
  use Micro.Web, :controller
  require Logger

  alias Micro.Category

  plug :scrub_params, "category" when action in [:create, :update]

  def index(conn, _params) do
    categories = Repo.all(Category)
    |> Repo.preload(:category)

    render(conn, "index.html", categories: categories)
  end

  def new(conn, _params) do
    changeset = Category.changeset(%Category{})

    query = from c in Micro.Category,
            select: {c.name, c.id}

    categories = Repo.all(query)
    all_categories = List.insert_at(categories, 0, {"", nil})

    render(conn, "new.html", changeset: changeset, categories: all_categories)
  end

  def create(conn, %{"category" => category_params}) do
    changeset = Category.changeset(%Category{}, category_params)

    case Repo.insert(changeset) do
      {:ok, _category} ->
        conn
        |> put_flash(:info, "Category created successfully.")
        |> redirect(to: category_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Repo.get!(Category, id) 
    |> Repo.preload [:products, :category] 

    render(conn, "show.html", category: category)
  end

  def edit(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)
    changeset = Category.changeset(category)

    query = from c in Micro.Category,
            select: {c.name, c.id}

    categories = Repo.all(query)
    all_categories = List.insert_at(categories, 0, {"", nil})

    render(conn, "edit.html", category: category, changeset: changeset, categories: all_categories)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Repo.get!(Category, id)
    changeset = Category.changeset(category, category_params)

    case Repo.update(changeset) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: category_path(conn, :show, category))
      {:error, changeset} ->
        render(conn, "edit.html", category: category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: category_path(conn, :index))
  end
end
