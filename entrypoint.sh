#!/bin/sh

env >> /etc/environment

auth_response=$(curl -X POST -H "Content-Type: application/json" -d '{
  "query": "mutation AuthenticateUser($email: String!, $password: String!) { authenticateUserWithPassword(email: $email, password: $password) { ... on UserAuthenticationWithPasswordSuccess { sessionToken } } }",
  "variables": {
    "email": "$BOT_EMAIL",
    "password": "$BOT_PASSWORD"
  }
}' $CMS_URL/api/graphql)

echo $auth_response

session_token=$(echo "$auth_response" | grep -o '"sessionToken":"[^"]*' | awk -F ':"' '{print $2}')

curl -X POST -H "Content-Type: application/json" --cookie "keystonejs-session=$session_token" $CMS_URL/rest/daily-product-count

# execute CMD
echo "$@"
exec "$@"
