# config valid only for current version of Capistrano
lock '3.4.0'

set :application, "Your app name"  # EDIT your app name
set :repo_url,  "https://github.com/laravel/laravel.git" # EDIT your git repository
set :deploy_to, "/var/www/my-app" # EDIT folder where files should be deployed to

set :keep_releases, 5

# set :linked_files, %w{.env} #EDIT uncomment this line once you have a .env file in :deploy_to/shared
set :linked_dirs, %w{storage}


namespace :composer do

#### Commented out because not everyone can run self update with deploy user

    # desc "Running Composer Self-Update"
    # task :update do
    #     on roles(:app), in: :sequence, wait: 5 do
    #         execute :composer, "self-update"
    #     end
    # end

    desc "Running Composer Install"
    task :install do
        on roles(:app), in: :sequence, wait: 5 do
            within release_path  do
                execute :composer, "install --no-dev --quiet"
            end
        end
    end

end

namespace :laravel do


    desc "Set up Laravel storage folders."
    task :create_storage do
    required_directories = [
          "#{shared_path}/storage/framework/cache",
          "#{shared_path}/storage/framework/meta",
          "#{shared_path}/storage/framework/sessions",
          "#{shared_path}/storage/framework/views",
          "#{shared_path}/storage/logs",
      ]
      on roles(:app) do
        required_directories.each do |directory|
          execute "if test ! -d #{directory}; then mkdir -m 777 -p #{directory} 1>&2; true; fi"
        end
      end
    end


    desc "Setup Laravel folder permissions"
    task :permissions do
        on roles(:app), in: :sequence, wait: 2 do
            within release_path  do
                execute :chmod, "u+x artisan"
                execute :chmod, "-R 777 storage"
                execute :chmod, "-R 777 bootstrap/cache"
            end
        end
    end

#### Doesn't work until you have a valid .env

    # desc "Run Laravel Artisan migrate task."
    # task :migrate do
    #     on roles(:app), in: :sequence, wait: 5 do
    #         within release_path  do
    #             execute :php, "artisan migrate"
    #         end
    #     end
    # end

#### Doesn't work until you have a valid .env

    # desc "Run Laravel Artisan seed task."
    # task :seed do
    #     on roles(:app), in: :sequence, wait: 5 do
    #         within release_path  do
    #             execute :php, "artisan db:seed"
    #         end
    #     end
    # end

    desc "Optimize Laravel Class Loader"
    task :optimize do
        on roles(:app), in: :sequence, wait: 5 do
            within release_path  do
                execute :php, "artisan clear-compiled"
                execute :php, "artisan optimize"
            end
        end
    end

end

namespace :deploy do

    # after :published, "composer:update"
    after :published, "composer:install"
    after :published, "laravel:permissions"
    after :published, "laravel:optimize"
    # after :published, "laravel:migrate"
    # after :published, "laravel:seed"

end
