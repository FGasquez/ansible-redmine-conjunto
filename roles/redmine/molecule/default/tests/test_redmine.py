import requests

def test_get_redmine_main_page(host):
     response = requests.get("http://localhost:8083")
     
     assert response.status_code == 200
     assert 'Redmine' in str(response.content)
