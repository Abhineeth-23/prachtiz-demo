require('dotenv').config();
const bcrypt = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');
const db = require('../db');

async function seed() {
  console.log('🌱 Seeding Prachtiz test data...');

  const hash = (pw) => bcrypt.hashSync(pw, 10);

  // Seed doctor
  const doctorId = uuidv4();
  await db.query(`
    INSERT INTO doctors (id, first_name, last_name, email, password_hash, phone, specialty, license)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
    ON CONFLICT (email) DO NOTHING
  `, [doctorId, 'Amanulla', 'Baig', 'dr.amanulla@prachtiz.com', hash('password123'), '+91 98765 43210', 'General Physician', 'MCI-123456']);

  // Seed receptionist
  const recepId = uuidv4();
  await db.query(`
    INSERT INTO receptionists (id, first_name, last_name, email, password_hash, phone, employee_id, shift, department, doctor_id)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
    ON CONFLICT (email) DO NOTHING
  `, [recepId, 'Meena', 'Reddy', 'meena.recep@prachtiz.com', hash('password123'), '+91 87654 32109', 'EMP-001', 'Morning', 'Front Desk', doctorId]);

  // Seed patient
  const patientId = uuidv4();
  await db.query(`
    INSERT INTO patients (id, first_name, last_name, email, password_hash, phone, dob, gender, blood_group, allergies, condition, insurance_partner, doctor_id)
    VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13)
    ON CONFLICT (email) DO NOTHING
  `, [patientId, 'Priya', 'Sharma', 'priya.patient@prachtiz.com', hash('password123'), '+91 76543 21098', '1990-05-18', 'Female', 'B+', JSON.stringify(['Sulfa Drugs']), 'Type 2 Diabetes', 'HDFC', doctorId]);

  // Seed appointment
  await db.query(`
    INSERT INTO appointments (patient_id, doctor_id, date, time, end_time, type, status, symptoms, consult_type, price, payment_status, partner_logo)
    VALUES ($1,$2,CURRENT_DATE,'10:30','11:00','Consultation','confirmed','Headache, Dizziness','General',500,'paid','HDFC')
    ON CONFLICT DO NOTHING
  `, [patientId, doctorId]);

  console.log('✅ Seed complete!');
  console.log('  Doctor:        dr.amanulla@prachtiz.com / password123');
  console.log('  Receptionist:  meena.recep@prachtiz.com / password123');
  console.log('  Patient:       priya.patient@prachtiz.com / password123');

  process.exit(0);
}

seed().catch((err) => {
  console.error('❌ Seed failed:', err.message);
  process.exit(1);
});
