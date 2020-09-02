# frozen_string_literal: true

class Recipe
  @@recipes = []

  attr_accessor :id, :title, :image_url, :description, :tags, :chef

  mattr_accessor :recipes

  def initialize(_id, _title, _image_url, _description, _tags, _chef)
    @id = _id
    @title = _title
    @image_url = _image_url
    @description = _description
    @tags = _tags
    @chef = _chef
  end

  def self.fetch_recipes
    @client ||= Contentful::Client.new(
      access_token: ENV['CONTENTFUL_ACCESS_TOKEN'],
      space: ENV['CONTENTFUL_SPACE_ID'],
      environment: ENV['Environment_ID'],
      dynamic_entries: :auto,
      raise_errors: true
    )
  end

  def self.all
    @@recipes = []
    recipes = fetch_recipes.entries('sys.contentType.sys.id[match]' => 'recipe', include: 2)
    recipes.each do |r|
      tags = r.fields[:tags] ? r.fields[:tags].collect(&:name).join(',') : ''
      chef = r.fields[:chef] ? r.fields[:chef].name : ''
      @@recipes << Recipe.new(
        r.sys[:id],
        r.fields[:title],
        r.fields[:photo].url(width: 800, height: 800, format: 'jpg', quality: 100),
        r.fields[:description],
        tags,
        chef
      )
    end
    @@recipes
  end
end
