# frozen_string_literal: true

class ContentfulController < ApplicationController
  def index
    @recipes = Recipe.all
  end

  def show
    @recipes = Recipe.recipes.blank? ? Recipe.all : Recipe.recipes
    @recipe = @recipes.select { |r|  r.id == params[:id] }[0]
  end
end
