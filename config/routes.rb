# frozen_string_literal: true

Spree::Core::Engine.routes.draw do
  unless SolidusContent.config.skip_default_route
    get '/c/:type(/:id)', to: 'solidus_content#show', id: :default, as: :solidus_content
  end
end
