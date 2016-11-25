## ContactApp

ContactApp deployed at DigitalOcean - <http://46.101.217.59:3006>.

#### To install application you need run commands:

1. `git clone https://github.com/kortirso/contacts_app.git`.
2. `cd contacts_app`.
3. _bundle install_.
4. rename application.yml.example to application.yml and fill with your secrets.
5. _rake db:create_.
6. _rake db:schema:load_.

#### To launch application:

1. In project folder run _rails s_.
3. Open http://localhost:3000.

#### To launch tests:

1. In project folder run _rspec_.

#### To set Facebook keys:

1. Visit `https://developers.facebook.com/docs/facebook-login`.
2. Creates new app.
3. Fill address url with your address.
4. Copy Facebook ID and Secret to your config/application.yml.

#### To get API description:

1. In project folder run _rails s_.
2. Open _http://localhost:3000/apipie_.

#### Using API with access_token:

1. In project folder run _rails s_.
2. Send POST request to `http://localhost:3000/oauth/token` with header `Content-Type: application/x-www-form-urlencoded` and raw body as `grant_type=password&username=YOUR_USERNAME&password=YOUR_PASSWORD`.
3. At response you will get json with access_token.
4. Use access_token for API actions.