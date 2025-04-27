📁 Complete File Structure
plaintext
Copy
Edit
Student-Record-Management/
│
├── backend/                   # Node.js + Express.js backend
│   ├── config/
│   │   └── db.js               # MySQL connection configuration
│   ├── controllers/
│   │   └── studentController.js # Logic for CRUD operations
│   ├── models/
│   │   └── studentModel.js      # Database queries (optional if you separate)
│   ├── routes/
│   │   └── studentRoutes.js     # API routes (CRUD)
│   ├── validations/
│   │   └── studentValidation.js # Backend form validation
│   ├── .env                    # Environment variables (DB config)
│   ├── server.js                # Entry point for backend
│   └── package.json             # Backend dependencies
│
├── frontend/                   # React.js frontend
│   ├── public/
│   │   └── index.html           # Main HTML file
│   ├── src/
│   │   ├── components/
│   │   │   ├── StudentForm.jsx   # Form to Add/Edit student
│   │   │   ├── StudentTable.jsx  # Table to show students
│   │   │   └── Navbar.jsx        # Navigation bar (optional)
│   │   ├── pages/
│   │   │   ├── Home.jsx          # Main page to show table
│   │   │   └── AddStudent.jsx    # Page to add new student
│   │   ├── services/
│   │   │   └── studentService.js # Axios calls to backend
│   │   ├── validations/
│   │   │   └── studentValidation.js # Frontend form validation logic
│   │   ├── App.jsx              # Main app with React Router
│   │   ├── index.js             # React app entry
│   │   └── App.css              # Global styling
│   ├── package.json             # Frontend dependencies
│
├── README.md                    # Project overview and setup guide
└── db/
    └── schema.sql               # SQL script to create the students table
✨ Quick explanation:
backend/ → Node.js Express app that manages API and database communication.

frontend/ → React app with form and table, handles client-side validation and view.

db/schema.sql → SQL script to create your students table.

.env → To store DB credentials like DB_HOST, DB_USER, etc.

services/studentService.js → Axios-based API calls (GET, POST, PUT, DELETE).

validations/ → Separate frontend and backend validation logic.

Bonus: Use React Router inside App.jsx if you want to have multiple pages like Add Student, View Students.

Would you also like me to give you a starter code for the backend folder (server.js, studentRoutes.js, etc.) so you can begin faster? 🚀
Or do you want a full step-by-step setup after this?


Sources






You said:
write code


ChatGPT said:
Perfect!
I'll start writing the backend first, step-by-step, matching the structure we discussed.
I'll make it clean and practical so you can just copy-paste and run it. 🚀

🛠️ Backend Code (/backend)
1. server.js
javascript
Copy
Edit
const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const studentRoutes = require('./routes/studentRoutes');

dotenv.config();
const app = express();

// Middlewares
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/students', studentRoutes);

// Server Listening
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
2. config/db.js
javascript
Copy
Edit
const mysql = require('mysql2');
const dotenv = require('dotenv');

dotenv.config();

const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME
});

db.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL:', err.message);
    process.exit(1);
  }
  console.log('Connected to MySQL database');
});

module.exports = db;
3. routes/studentRoutes.js
javascript
Copy
Edit
const express = require('express');
const router = express.Router();
const studentController = require('../controllers/studentController');

// CRUD Routes
router.get('/', studentController.getAllStudents);
router.post('/', studentController.createStudent);
router.put('/:id', studentController.updateStudent);
router.delete('/:id', studentController.deleteStudent);

module.exports = router;
4. controllers/studentController.js
javascript
Copy
Edit
const db = require('../config/db');
const { validateStudent } = require('../validations/studentValidation');

// Get All Students
exports.getAllStudents = (req, res) => {
  const sql = 'SELECT * FROM students';
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
};

// Create a New Student
exports.createStudent = (req, res) => {
  const { error } = validateStudent(req.body);
  if (error) return res.status(400).json({ error: error.details[0].message });

  const sql = 'INSERT INTO students SET ?';
  db.query(sql, req.body, (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'Student added successfully' });
  });
};

// Update a Student
exports.updateStudent = (req, res) => {
  const { error } = validateStudent(req.body);
  if (error) return res.status(400).json({ error: error.details[0].message });

  const sql = 'UPDATE students SET ? WHERE id = ?';
  db.query(sql, [req.body, req.params.id], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'Student updated successfully' });
  });
};

// Delete a Student
exports.deleteStudent = (req, res) => {
  const sql = 'DELETE FROM students WHERE id = ?';
  db.query(sql, req.params.id, (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'Student deleted successfully' });
  });
};
5. validations/studentValidation.js
javascript
Copy
Edit
const Joi = require('joi');

exports.validateStudent = (student) => {
  const schema = Joi.object({
    name: Joi.string().min(3).pattern(new RegExp('^[A-Za-z ]+$')).required(),
    email: Joi.string().email().required(),
    course: Joi.string().required(),
    address: Joi.string().pattern(new RegExp('^[#.0-9a-zA-Z\\s,-]+$')).required(),
    mobile: Joi.string().min(10).max(15).required(),
    dob: Joi.date().required()
  });

  return schema.validate(student);
};
6. .env
plaintext
Copy
Edit
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=studentdb
PORT=5000
7. SQL Table db/schema.sql
sql
Copy
Edit
CREATE DATABASE IF NOT EXISTS studentdb;

USE studentdb;

CREATE TABLE IF NOT EXISTS students (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  course VARCHAR(255) NOT NULL,
  address VARCHAR(255) NOT NULL,
  mobile VARCHAR(20) NOT NULL,
  dob DATE NOT NULL
);
📦 Backend Dependencies
Run this in your /backend folder:

bash
Copy
Edit
npm init -y
npm install express cors mysql2 dotenv joi
✅ Backend is Ready!
Once you run:

bash
Copy
Edit
node server.js
The backend API will be live at http://localhost:5000/api/students.

🎯 Next: Frontend (React)
Would you like me to start the Frontend setup next?
I'll give you ready React components (StudentForm.jsx, StudentTable.jsx) too! 🚀
Shall I continue? 👨‍💻







You said:
do it and use bootstrap 5 for styling 


ChatGPT said:
Awesome!
I'll now write the Frontend (React) for you, using Bootstrap 5 for styling, and matching your assignment needs perfectly! 🚀

🖥️ Frontend Code (/frontend)
1. index.js
javascript
Copy
Edit
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import 'bootstrap/dist/css/bootstrap.min.css'; // Import Bootstrap
import './App.css';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
2. App.jsx
javascript
Copy
Edit
import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Home from './pages/Home';
import AddStudent from './pages/AddStudent';
import Navbar from './components/Navbar';

function App() {
  return (
    <Router>
      <Navbar />
      <div className="container mt-4">
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/add" element={<AddStudent />} />
          <Route path="/edit/:id" element={<AddStudent />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
3. components/Navbar.jsx
javascript
Copy
Edit
import React from 'react';
import { Link } from 'react-router-dom';

function Navbar() {
  return (
    <nav className="navbar navbar-expand-lg navbar-dark bg-primary">
      <div className="container">
        <Link className="navbar-brand" to="/">Student Management</Link>
        <div className="collapse navbar-collapse">
          <ul className="navbar-nav ms-auto">
            <li className="nav-item">
              <Link className="btn btn-light" to="/add">Add Student</Link>
            </li>
          </ul>
        </div>
      </div>
    </nav>
  );
}

export default Navbar;
4. pages/Home.jsx
javascript
Copy
Edit
import React, { useEffect, useState } from 'react';
import StudentTable from '../components/StudentTable';
import studentService from '../services/studentService';

function Home() {
  const [students, setStudents] = useState([]);

  useEffect(() => {
    fetchStudents();
  }, []);

  const fetchStudents = async () => {
    const res = await studentService.getAll();
    setStudents(res.data);
  };

  const deleteStudent = async (id) => {
    if (window.confirm('Are you sure you want to delete this student?')) {
      await studentService.remove(id);
      fetchStudents();
    }
  };

  return (
    <div>
      <h2>Student List</h2>
      <StudentTable students={students} deleteStudent={deleteStudent} />
    </div>
  );
}

export default Home;
5. pages/AddStudent.jsx
javascript
Copy
Edit
import React, { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import StudentForm from '../components/StudentForm';
import studentService from '../services/studentService';

function AddStudent() {
  const [student, setStudent] = useState({
    name: '',
    email: '',
    course: '',
    address: '',
    mobile: '',
    dob: ''
  });
  const navigate = useNavigate();
  const { id } = useParams();

  useEffect(() => {
    if (id) {
      loadStudent();
    }
  }, [id]);

  const loadStudent = async () => {
    const res = await studentService.getAll();
    const found = res.data.find((stu) => stu.id === parseInt(id));
    if (found) setStudent(found);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (id) {
      await studentService.update(id, student);
    } else {
      await studentService.create(student);
    }
    navigate('/');
  };

  return (
    <div>
      <h2>{id ? 'Edit' : 'Add'} Student</h2>
      <StudentForm student={student} setStudent={setStudent} handleSubmit={handleSubmit} />
    </div>
  );
}

export default AddStudent;
6. components/StudentForm.jsx
javascript
Copy
Edit
import React, { useState } from 'react';
import { validateStudent } from '../validations/studentValidation';

function StudentForm({ student, setStudent, handleSubmit }) {
  const [errors, setErrors] = useState({});

  const handleChange = (e) => {
    setStudent({ ...student, [e.target.name]: e.target.value });
  };

  const validateForm = () => {
    const result = validateStudent(student);
    if (result.error) {
      const field = result.error.details[0].context.key;
      setErrors({ [field]: result.error.details[0].message });
      return false;
    }
    setErrors({});
    return true;
  };

  const onSubmit = (e) => {
    e.preventDefault();
    if (validateForm()) {
      handleSubmit(e);
    }
  };

  return (
    <form noValidate onSubmit={onSubmit}>
      <div className="mb-3">
        <label>Name</label>
        <input type="text" name="name" className="form-control" value={student.name} onChange={handleChange} />
        {errors.name && <div className="text-danger">{errors.name}</div>}
      </div>

      <div className="mb-3">
        <label>Email</label>
        <input type="email" name="email" className="form-control" value={student.email} onChange={handleChange} />
        {errors.email && <div className="text-danger">{errors.email}</div>}
      </div>

      <div className="mb-3">
        <label>Course</label>
        <select name="course" className="form-select" value={student.course} onChange={handleChange}>
          <option value="">Select Course</option>
          <option value="BCA">BCA</option>
          <option value="MCA">MCA</option>
          <option value="MBA">MBA</option>
          <option value="BBA">BBA</option>
        </select>
        {errors.course && <div className="text-danger">{errors.course}</div>}
      </div>

      <div className="mb-3">
        <label>Address</label>
        <input type="text" name="address" className="form-control" value={student.address} onChange={handleChange} />
        {errors.address && <div className="text-danger">{errors.address}</div>}
      </div>

      <div className="mb-3">
        <label>Mobile</label>
        <input type="text" name="mobile" className="form-control" value={student.mobile} onChange={handleChange} />
        {errors.mobile && <div className="text-danger">{errors.mobile}</div>}
      </div>

      <div className="mb-3">
        <label>Date of Birth</label>
        <input type="date" name="dob" className="form-control" value={student.dob} onChange={handleChange} />
        {errors.dob && <div className="text-danger">{errors.dob}</div>}
      </div>

      <button className="btn btn-primary" type="submit">
        Save
      </button>
    </form>
  );
}

export default StudentForm;
7. components/StudentTable.jsx
javascript
Copy
Edit
import React from 'react';
import { Link } from 'react-router-dom';

function StudentTable({ students, deleteStudent }) {
  return (
    <table className="table table-bordered">
      <thead className="table-dark">
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>Email</th>
          <th>Course</th>
          <th>Address</th>
          <th>Mobile</th>
          <th>DOB</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        {students.length > 0 ? (
          students.map((stu) => (
            <tr key={stu.id}>
              <td>{stu.id}</td>
              <td>{stu.name}</td>
              <td>{stu.email}</td>
              <td>{stu.course}</td>
              <td>{stu.address}</td>
              <td>{stu.mobile}</td>
              <td>{stu.dob.slice(0, 10)}</td>
              <td>
                <Link to={`/edit/${stu.id}`} className="btn btn-warning btn-sm me-2">Edit</Link>
                <button onClick={() => deleteStudent(stu.id)} className="btn btn-danger btn-sm">Delete</button>
              </td>
            </tr>
          ))
        ) : (
          <tr>
            <td colSpan="8" className="text-center">No Students Found</td>
          </tr>
        )}
      </tbody>
    </table>
  );
}

export default StudentTable;
8. services/studentService.js
javascript
Copy
Edit
import axios from 'axios';

const API_URL = 'http://localhost:5000/api/students';

const getAll = () => axios.get(API_URL);
const create = (data) => axios.post(API_URL, data);
const update = (id, data) => axios.put(`${API_URL}/${id}`, data);
const remove = (id) => axios.delete(`${API_URL}/${id}`);

const studentService = { getAll, create, update, remove };

export default studentService;
9. validations/studentValidation.js
javascript
Copy
Edit
import Joi from 'joi';

export const validateStudent = (student) => {
  const schema = Joi.object({
    name: Joi.string().min(3).pattern(new RegExp('^[A-Za-z ]+$')).required(),
    email: Joi.string().email().required(),
    course: Joi.string().required(),
    address: Joi.string().pattern(new RegExp('^[#.0-9a-zA-Z\\s,-]+$')).required(),
    mobile: Joi.string().min(10).max(15).required(),
    dob: Joi.date().required()
  });

  return schema.validate(student);
};
📦 Frontend Dependencies
In /frontend folder, run:

bash
Copy
Edit
npx create-react-app .
npm install axios react-router-dom joi bootstrap
🎯 Now your Full Stack app is ready to go!
Start backend → /backend → node server.js

Start frontend → /frontend → npm start

⚡ Recap:
✅ Bootstrap 5 styling
✅ React Router for navigation
✅ Axios for API
✅ Client + Server Validation
✅ Complete CRUD

Would you also like me to give you a single GitHub README.md file ready to upload? 🚀
(Professional touch!)
Want me to create that too? 📄✨
