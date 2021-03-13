# This module was implemented and taken from Tuck notes 0309 photos.ex
# The file can be found at 
# https://github.com/NatTuck/scratch-2021-01/blob/master/4550/0309/photo_blog/lib/photo_blog/photos.ex
defmodule Events.Photos do
  # Is Valid Photo
  def is_valid_photo(photo) do
    IO.inspect photo
    !String.ends_with?(photo.filename, "jpg") && 
      !String.ends_with?(photo.filename, "png") && 
      !String.ends_with?(photo.filename, "gif")
  end

  # Saves the photo given the name and path of the photo file
  def save_photo(name, path) do
    data = File.read!(path)
    hash = sha256(data)
    meta = read_meta(hash)
    save_photo(name, data, hash, meta)
  end

  def save_photo(name, data, hash, nil) do
    File.mkdir_p!(base_path(hash))
    meta = %{
      name: name,
      refs: 0,
    }
    save_photo(name, data, hash, meta)
  end

  def save_photo(_name, data, hash, meta) do
    meta = Map.update!(meta, :refs, &(&1 + 1))
    File.write!(meta_path(hash), Jason.encode!(meta))
    File.write!(data_path(hash), data)
    {:ok, hash}
  end

  def load_photo(hash) do
    data = File.read!(data_path(hash))
    meta = File.read!(meta_path(hash))
    |> Jason.decode!
    {:ok, Map.get(meta, :name), data}
  end

  def read_meta(hash) do
    with {:ok, data} <- File.read(meta_path(hash)),
         {:ok, meta} <- Jason.decode(data, keys: :atoms)
    do
      meta
    else
      _ -> nil
    end
  end

  def base_path(hash) do
    Path.expand("~/.local/data/events")
    |> Path.join(String.slice(hash, 0, 2))
    |> Path.join(String.slice(hash, 2, 30))
  end

  def meta_path(hash) do
    Path.join(base_path(hash), "meta.json")
  end

  def data_path(hash) do
    Path.join(base_path(hash), "photo.jpg")
  end

  def sha256(data) do
    :crypto.hash(:sha256, data)
    |> Base.encode16(case: :lower)
  end
end