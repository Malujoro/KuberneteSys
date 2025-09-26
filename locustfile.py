from locust import HttpUser, task, between

class UsuarioAPI(HttpUser):
    host = "http://10.180.47.29:8081"   # endereço base da API
    wait_time = between(1, 3)           # cada usuário espera 1 a 3s entre as requisições

    @task
    def acessar_docs(self):
        self.client.get("/produtos")        # faz requisição para /docs
