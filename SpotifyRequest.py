import requests
import json

class spotifyapiretrieval:

    def __init__(self,client_id, client_secret ):
        self.client_id = client_id 
        self.client_secret = client_secret 
        self.token = self.request_token()


    def request_token(self):
        auth_url = "https://accounts.spotify.com/api/token"
        try:
            auth_response = requests.post(auth_url, {
                'grant_type': 'client_credentials',
                'client_id': self.client_id,
                'client_secret': self.client_secret,
            })
            auth_response.raise_for_status()  
            auth_response_data = auth_response.json()
            return auth_response_data.get('access_token') 
        
        except requests.exceptions.RequestException as e:
            print(f"Error obtaining token: {e}")
            return None


    def get_playlist(self,playlist_id,):
        if not self.token:
            print("No access token available. Please request again.")
            return None

        url = f"https://api.spotify.com/v1/playlists/{playlist_id}"
        headers = {
            'Authorization': f'Bearer {self.token}',
        }
        try:
            response = requests.get(url, headers=headers)
            response.raise_for_status()  # Raises an error for HTTP codes 4xx/5xx
            return response.json()
        except requests.exceptions.RequestException as e:
            print(f"Request error: {e}")


    def playlist_json_output(self, file_name, playlist_data):
        if playlist_data is None:
            print("No data to write to file.")
            return

        try:
            with open(file_name, 'w') as f:
                json.dump(playlist_data, f, indent=4)
            print(f"Playlist data saved to {file_name}")
        
        except IOError as e:
            print(f"Error writing to file {file_name}: {e}")

if __name__ == "__main__":
    client_id = "de21e4390faf42f296f755475415b6c6"
    client_secret = "75ba223395624c818eaa722e76c2e1ec" 
    api = spotifyapiretrieval(client_id, client_secret)
     
    playlist_dict = {'Haitian_Party':'77Y0FzsMxplH9yAUJnbcJU', 
                     'Kompas_Mix': '61lwMlheSWEXBMFvNRRJ8v', 
                     'Dancehall_2024': '7BSOtcmHO8enyDLGteYQFN', 
                     'Best_Dancehall':'2UMKYqQerklVrFgXRCk77s',
                    'Soca_2024':'5kCjHM5mKmf7axrWecdkuz', 
                    'Best_Soca_Hits':'57fWJm8r4N8SDEhunDGbpE'}

    
  

for name, playlist_id in playlist_dict.items():
    playlist_data = api.get_playlist(playlist_id)
    output_file = f"/Users/neissachery/Downloads/{name}.json"
    api.playlist_json_output(output_file, playlist_data)
    
