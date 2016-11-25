lock '3.6.1'

set :application, 'contacts_app'
set :repo_url, 'git@github.com:kortirso/contacts_app.git'

set :deploy_to, '/var/www/html/contacts_app'
set :deploy_user, 'kortirso'

set :linked_files, fetch(:linked_files, []).push('config/application.yml')

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

namespace :deploy do
    desc 'Restart application'
    task :restart do
        on roles(:app), in: :sequence, wait: 5 do
            execute :touch, release_path.join('tmp/restart.txt')
        end
    end

    after :publishing, :restart
end