# frozen_string_literal: true
Rails.application.routes.draw do
  resources 'empty'
  resources 'redirect'
  resources 'data'
  resources 'file'
  resources 'halt'
  resources 'fragment'
end
