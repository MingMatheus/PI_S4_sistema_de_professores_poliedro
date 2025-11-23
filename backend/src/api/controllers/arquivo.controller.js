const mongoose = require("mongoose")
const fs = require('fs');

const Arquivo = require("../../models/Arquivo.model")
const Pasta = require("../../models/Pasta.model")

const {
  MONGO_DUPLICATE_KEY,
  MONGOOSE_VALIDATION_ERROR,
  MULTER_LIMIT_FILE_SIZE
} = require("../../constants/error.constants")

const {
  ARQUIVO,
  PASTA,
  ERRO,
  AUTH
} = require("../../constants/responseMessages.constants")

exports.createArquivo = async (req, res) => {
  try {
    if(!req.file)
      return res.status(400).json({mensagem: ARQUIVO.ARQUIVO_NAO_ENVIADO});

    const { pastaOndeSeEncontra } = req.body;
    const { originalname, filename, size, mimetype, path } = req.file;

    const url = `http://localhost:${process.env.API_PORT}/files/${filename}`;

    const arquivo = new Arquivo({
      nomeOriginal: originalname,
      nomeNoSistema: filename,
      tamanho: size,
      tipo: mimetype,
      caminho: path,
      url: url,
      pastaOndeSeEncontra: pastaOndeSeEncontra || null,
      professorQueFezOUpload: req.user.sub
    });

    await arquivo.save();

    res.status(201).json({
      mensagem: ARQUIVO.CRIADO_COM_SUCESSO,
      arquivo: arquivo
    });
  } catch (error) {
    if (error.code == MONGO_DUPLICATE_KEY) {
      return res.status(409).json({ mensagem: ARQUIVO.NOME_EM_USO });
    }

    if (error.name == MONGOOSE_VALIDATION_ERROR) {
      const errorMessages = Object.values(error.errors).map(err => err.message);
      return res.status(400).json({
        mensagem: ERRO.VALIDACAO,
        erros: errorMessages
      });
    }

    // O multer pode gerar erros (ex: tipo de arquivo inválido)
    if(error instanceof multer.MulterError)
    {
      if(error.code === MULTER_LIMIT_FILE_SIZE)
        return res.status(400).json({message: ARQUIVO.ARQUIVO_MUITO_GRANDE});
    }

    // O filtro de arquivo gera um erro padrão
    if(error.message === ARQUIVO.TIPO_DE_ARQUIVO_INVALIDO)
      return res.status(400).json({ message: ARQUIVO.TIPO_DE_ARQUIVO_INVALIDO });

    return res.status(500).json({ mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR });
  }
};

exports.getTodosArquivos = async (req, res) => {
  try
  {
    // By default, fetches files in the root directory.
    // A query param could be added to fetch files from a specific folder.
    const arquivos = await Arquivo.find({ pastaOndeSeEncontra: null })
      .select("-__v -nomeNoSistema -caminho")
      .populate("professorQueFezOUpload", "nome -_id")

    res.status(200).json({
      mensagem: ARQUIVO.TODOS_ARQUIVOS_ENCONTRADOS,
      arquivos: arquivos
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.getArquivoById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: ARQUIVO.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: ARQUIVO.ID_FORNECIDO_INVALIDO})

    const arquivo = await Arquivo.findById(id)
      .select("-__v -nomeNoSistema -caminho")
      .populate("professorQueFezOUpload", "nome -_id")
      .populate({
        path: "pastaOndeSeEncontra",
        select: "nome pastaPai",
        populate: {
          path: "pastaPai",
          select: "nome"
        }
      })

    if (!arquivo)
      return res.status(404).json({mensagem: ARQUIVO.NAO_ENCONTRADO})

    res.status(200).json({
      mensagem: ARQUIVO.ENCONTRADO_COM_SUCESSO,
      arquivo: arquivo
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.updateArquivoById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: ARQUIVO.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: ARQUIVO.ID_FORNECIDO_INVALIDO})

    const { nomeOriginal } = req.body

    const arquivo = await Arquivo.findById(id)

    if (!arquivo)
      return res.status(404).json({mensagem: ARQUIVO.NAO_ENCONTRADO})

    if(arquivo.professorQueFezOUpload.toString() !== req.user.sub)
       return res.status(403).json({mensagem: AUTH.NAO_TEM_PERMISSAO})

    if(nomeOriginal) arquivo.nomeOriginal = nomeOriginal

    await arquivo.save()

    res.status(200).json({
      mensagem: ARQUIVO.ATUALIZADO_COM_SUCESSO,
      arquivo: arquivo
    })
  }
  catch(error)
  {
    if(error.code == MONGO_DUPLICATE_KEY)
    {
      return res.status(409).json({mensagem: ARQUIVO.NOME_EM_USO})
    }

    if(error.name == MONGOOSE_VALIDATION_ERROR)
    {
      const errorMessages = Object.values(error.errors).map(err => err.message);
      return res.status(400).json({
        mensagem: ERRO.VALIDACAO,
        erros: errorMessages
      })
    }

    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.deleteArquivoById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: ARQUIVO.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: ARQUIVO.ID_FORNECIDO_INVALIDO})
      
    const arquivo = await Arquivo.findById(id)
      .select("professorQueFezOUpload nomeNoSistema caminho")

    if (!arquivo)
      return res.status(404).json({mensagem: ARQUIVO.NAO_ENCONTRADO});

    if (arquivo.professorQueFezOUpload.toString() !== req.user.sub)
      return res.status(403).json({mensagem: AUTH.NAO_TEM_PERMISSAO});

    const arquivoDeletadoDoDB =await Arquivo.findByIdAndDelete(id)
      .select("-__v -nomeNoSistema -caminho")
      .populate("professorQueFezOUpload", "nome -_id")
      .populate({
        path: "pastaOndeSeEncontra",
        select: "nome pastaPai",
        populate: {
          path: "pastaPai",
          select: "nome"
        }
      })

    if (!arquivoDeletadoDoDB)
      return res.status(404).json({mensagem: ARQUIVO.NAO_ENCONTRADO});

    try
    {
      // Faz a remoção do arquivo no disco
      await fs.promises.unlink(arquivo.caminho); 
    }
    catch(fsError)
    {
      console.warn(
        `(AVISO) O registro do arquivo ${arquivo.nomeNoSistema} (ID: ${id}) foi deletado do DB, mas a deleção do arquivo físico em '${arquivo.caminho}' falhou.`, 
        fsError.message
      );
    }

    res.status(200).json({
      mensagem: ARQUIVO.DELETADO_COM_SUCESSO,
      arquivo: arquivoDeletadoDoDB
    })
  }
  catch(error)
  {
    console.error('Erro ao deletar arquivo:', error);
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.getArquivoByPasta = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: PASTA.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: PASTA.ID_FORNECIDO_INVALIDO})

    const pasta = await Pasta.findById(id).select("nome")

    if(!pasta)
      return res.status(404).json({mensagem: PASTA.NAO_ENCONTRADA})

    const arquivos = await Arquivo.find({pastaOndeSeEncontra: id})
      .select("-__v -nomeNoSistema -caminho")
      .populate("professorQueFezOUpload", "nome -_id")
      .populate({
        path: "pastaOndeSeEncontra",
        select: "nome pastaPai",
        populate: {
          path: "pastaPai",
          select: "nome"
        }
      })

    res.status(200).json({
      mensagem: ARQUIVO.ARQUIVOS_DA_PASTA_ENCONTRADOS_COM_SUCESSO,
      arquivo: arquivos
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}
