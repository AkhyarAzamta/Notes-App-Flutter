// src/routes/index.js
import { Router } from 'express';
import { authController } from '../controllers/auth.js';
import { authHander } from '../middleware/auth.js';
import { profileController } from '../controllers/profile.js';
import { notesController } from '../controllers/notes.js';

export const router = Router();

router.post('/register', authController.register);
router.post('/login', authController.login);

// Middleware otentikasi di sini, akan diterapkan ke semua rute berikutnya
router.use(authHander);

router.get('/profile', profileController);
router.post('/notes', notesController.create);
router.get('/notes', notesController.get);
router.get('/notes/:id', notesController.getOne);
router.patch('/notes/:id', notesController.update);
router.delete('/notes/:id', notesController.delete);
