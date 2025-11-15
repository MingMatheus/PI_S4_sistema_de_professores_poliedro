const multer = require('multer');
const path = require('path');
const crypto = require('crypto');

const {
  ARQUIVO
} = require("../constants/responseMessages.constants"); // Importa suas mensagens

// Define onde os arquivos serão armazenados
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    // Define o caminho absoluto para a pasta 'uploads' na raiz do seu backend
    cb(null, path.resolve(__dirname, '..', '..', 'uploads'));
  },
  filename: (req, file, cb) => {
    // Gera um nome de arquivo único para evitar conflitos
    crypto.randomBytes(16, (err, hash) => {
      if (err) cb(err);
      const nomeUnico = `${hash.toString('hex')}-${file.originalname}`;
      cb(null, nomeUnico);
    });
  },
});

// Configuração completa do multer
const multerConfig = {
  dest: path.resolve(__dirname, '..', '..', 'uploads'),
  storage: storage,

  // Limite de tamanho do arquivo (ex: 5MB)
  limits: {
    fileSize: 5 * 1024 * 1024, // 5 megabytes
  },

  // Filtro de tipos de arquivo
  fileFilter: (req, file, cb) => {
    const allowedMimes = [
      'image/jpeg',
      'image/png',
      'application/pdf',
      'application/msword', // .doc
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document' // .docx
    ];

    if (allowedMimes.includes(file.mimetype)) {
      cb(null, true); // Aceita o arquivo
    } else {
      // Rejeita o arquivo com uma mensagem de erro específica
      cb(new Error(ARQUIVO.TIPO_DE_ARQUIVO_INVALIDO));
    }
  },
};

module.exports = multerConfig;
