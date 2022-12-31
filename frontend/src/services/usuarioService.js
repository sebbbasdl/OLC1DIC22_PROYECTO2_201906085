class usuarioService {//servicios para login
    axios
    baseUrl
  
    constructor(axios, baseUrl) {
      this.axios = axios;
      this.baseUrl = `${baseUrl}`;
    }

    realizarAnalisis(body){
      console.log(this.baseUrl)
      let ruta = `${this.baseUrl}/api/parse`
      return this.axios.post(ruta, body);
    }
}

export default usuarioService;