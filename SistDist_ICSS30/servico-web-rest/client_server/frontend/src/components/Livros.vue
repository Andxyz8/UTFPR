<template>
    <div class="jumbotron vertical-center">
        <div class="container">
            <div class="row">
                <div class="col-sm-12 ">
                    <h1 class="text-center bg-primary text-white" style="border-radius:10px"> Biblioteca Virtual </h1>
                    <hr><br>

                    <b-alert variant="success" v-if="showMessage" show> {{ message }} </b-alert>
                    <button type="button" class="btn btn-success btn-sm" v-b-modal.livro-modal>Adicionar Livro</button>
                    <br><br>
                    <table class="table table-hover">
                    <thead>
                        <tr>
                            <th scope="col">Titulo</th>
                            <th scope="col">Genero</th>
                            <th scope="col">Autor</th>
                            <th scope="col">Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                    <tr v-for="(livro, index) in livros" :key="index">
                        <td>{{livro.titulo}}</td>
                        <td>{{livro.genero}}</td>
                        <td>{{livro.autor}}</td>
                        <td>
                            <div class="btn-group" role="group">
                                <button
                                    type="button"
                                    class="btn btn-info btn-sm"
                                    v-b-modal.livro-update-modal
                                    @click="editLivro(livro)"> Atualizar 
                                </button>
                                <button type="button" class="btn btn-danger btn-sm" @click="deleteLivro(livro)">Remover</button>
                            </div>
                        </td>
                    </tr>
                    </tbody>
                    </table>
                </div>
            </div>

        <b-modal ref="addLivroModal"
            id="livro-modal"
            title="Adicionar Livro" hide-backdrop
            hide-footer
        >
        <b-form @submit="onSubmit" @reset="onReset" class="w-100">
        <b-form-group id="form-title-group"
                    label="Título:"
                    label-for="form-title-input">
            <b-form-input id="form-title-input"
                    type="text"
                    v-model="addLivroForm.titulo"
                    required
                    placeholder="Título">
            </b-form-input>
        </b-form-group>

        <b-form-group id="form-genre-group"
                    label="Genêro:"
                    label-for="form-genre-input">
            <b-form-input id="form-genre-input"
                        type="text"
                        v-model="addLivroForm.genero"
                        required
                        placeholder="Genêro">
            </b-form-input>
        </b-form-group>

        <b-form-group id="form-author-group"
                    label="Autor:"
                    label-for="form-author-input">
            <b-form-input id="form-author-input"
                        type="text"
                        v-model="addLivroForm.autor"
                        required
                        placeholder="Autor">
            </b-form-input>
        </b-form-group>

        <b-button type="submit" variant="outline-info">Salvar</b-button>
        <b-button type="reset" variant="outline-danger">Excluir</b-button>
        </b-form>
        </b-modal>


    <b-modal ref="editLivroModal"
            id="livro-update-modal"
            title="Update" hide-backdrop
            hide-footer>
    <b-form @submit="onSubmitUpdate" @reset="onResetUpdate" class="w-100">
        
    <b-form-group id="form-title-edit-group"
                    label="Título:"
                    label-for="form-title-edit-input">
        <b-form-input id="form-title-edit-input"
                        type="text"
                        v-model="editForm.titulo"
                        required
                        placeholder="Título">
        </b-form-input>
        </b-form-group>

        <b-form-group id="form-genre-edit-group"
                    label="Genêro:"
                    label-for="form-genre-edit-input">
            <b-form-input id="form-genre-edit-input"
                        type="text"
                        v-model="editForm.genero"
                        required
                        placeholder="Genêro">
            </b-form-input>
        </b-form-group>

        <b-form-group id="form-author-edit-group"
                    label="Autor:"
                    label-for="form-author-edit-input">
            <b-form-input id="form-author-edit-input"
                        type="text"
                        v-model="editForm.autor"
                        required
                        placeholder="Autor">
            </b-form-input>
        </b-form-group>
        
        <b-button-group>
        <b-button type="submit" variant="outline-info">Update</b-button>
        <b-button type="reset" variant="outline-danger">Cancel</b-button>
        </b-button-group>
    </b-form>
    </b-modal>
    </div>
    </div>
</template>



<script>
import axios from 'axios';

export default {
  data() {
    return {
      livros: [],
      addLivroForm: {
        id_livro: '',
        titulo: '',
        genero: '',
        autor: '',
      },
      editForm: {
        id_livro: '',
        titulo: '',
        genero: '',
        autor: '',
      },
    };
  },

  message:'',

methods: {
    // 1 GET METHOD
    getLivros() {
      const path = 'http://192.168.15.7:5000/livros';
      axios.get(path)
        .then((res) => {
          this.livros = res.data.livros;
        })
        .catch((error) => {
          console.error(error);
        });
    },

    // 2 Add Livro Button
    addLivro(payload) {
      const path = 'http://192.168.15.7:5000/livros';
      axios.post(path, payload)
        .then(() => {
          this.getLivros();
          
          // for message alert
          this.message = 'Livro added 🕹️ !';
          
          // to show message when Livro is added
          this.showMessage = true;
  
        })
        .catch((error) => {
          console.log(error);
          this.getLivros();
        });
    },

     // 5 initForm - add ediForm after the update method
     initForm() {
        this.addLivroForm.titulo = '';
        this.addLivroForm.genero = '';
        this.addLivroForm.autor = '';
        this.editForm.id_livro = '';
        this.editForm.titulo = '';
        this.editForm.genero = '';
        this.editForm.autor = '';
      }, 

    // 3 Submit form validator in the template @submit="onSubmit"  
    onSubmit(e) {
      e.preventDefault();
      this.$refs.addLivroModal.hide();
      const payload = {
        titulo: this.addLivroForm.titulo,
        genero: this.addLivroForm.genero,
        autor: this.addLivroForm.autor,
      };
      this.addLivro(payload);
      this.initForm();
    },

    
  // MODAL 2
  // a- Handle the form Submit after updating
    onSubmitUpdate(e) {
    e.preventDefault();
    this.$refs.editLivroModal.hide();
    const payload = {
      titulo: this.editForm.titulo,
      genero: this.editForm.genero,
      autor: this.editForm.autor,
    };
    this.updateLivro(payload, this.editForm.id_livro);
  },

  // b- On reset method to reset items to default values
    onReset(e) {
      e.preventDefault();
      this.$refs.addLivroModal.hide();
      this.initForm();
    },

// 4 Update Alert Message 
// Once the update is effective, we will get a message telling us that Livro Updated, and display the list of livros after the update
updateLivro(payload, livroID) {
  const path = `http://192.168.15.7:5000/livros/${livroID}`;
  axios.put(path, payload)    
    .then(() => {
      this.getLivros();
      this.message = 'Livro updated ⚙️!';
      this.showMessage =  true;
    })
    .catch((error) => {
      console.error(error);
      this.getLivros();
    });
},

 // Handle Update Button 
editLivros(livro) {
  this.editForm = livro;
},

// 5 Handle reset / cancel button click
onResetUpdate(e) {
  e.preventDefault();
  this.$refs.editLivroModal.hide();
  this.initForm();
  this.getLivros(); 
},

// Remove Livro [ Delete Button ]
removeLivro(livroID) {
  const path = `http://192.168.15.7:5000/livros/${livroID}`;
  axios.delete(path)
    .then(() => {
      this.getlivros();
      this.message = 'Livro Removed 🗑️!';
      this.showMessage = true;
    })
    .catch((error) => {
      // eslint-disable-next-line
      console.error(error);
      this.getLivros();
    });
},
// Handle Delete Button
deleteLivro(livro) {
  this.removeLivro(livro.id_livro);
},

  },
  created() {
    this.getLivros(); 
  },
};
</script>