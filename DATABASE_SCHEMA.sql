-- =====================================================
-- COOGUARPENAL Database Schema
-- Version: 1.0
-- Description: Complete database schema for cooperative management system
-- =====================================================

-- Enable UUID extension for PostgreSQL
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- USERS AND AUTHENTICATION
-- =====================================================

-- User roles enum
CREATE TYPE user_role AS ENUM ('member', 'admin', 'manager', 'auditor');

-- User status enum  
CREATE TYPE user_status AS ENUM ('active', 'inactive', 'suspended', 'pending_approval');

-- Users table (associates and staff)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role user_role NOT NULL DEFAULT 'member',
    status user_status NOT NULL DEFAULT 'pending_approval',
    
    -- Personal information
    cedula VARCHAR(20) UNIQUE NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    telefono VARCHAR(20),
    celular VARCHAR(20),
    direccion TEXT,
    ciudad VARCHAR(100),
    departamento VARCHAR(100),
    
    -- Employment information
    lugar_trabajo VARCHAR(200),
    cargo VARCHAR(100),
    salario_base DECIMAL(15,2),
    fecha_ingreso_cooperativa DATE,
    numero_asociado VARCHAR(20) UNIQUE,
    
    -- Financial settings
    descuento_maximo_porcentaje DECIMAL(5,2) DEFAULT 30.00,
    
    -- System fields
    email_verified BOOLEAN DEFAULT FALSE,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id)
);

-- Password reset tokens
CREATE TABLE password_reset_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(255) NOT NULL UNIQUE,
    expires_at TIMESTAMP NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User sessions for security tracking
CREATE TABLE user_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash VARCHAR(255) NOT NULL,
    ip_address INET,
    user_agent TEXT,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- FINANCIAL PRODUCTS AND SERVICES
-- =====================================================

-- Loan types
CREATE TYPE loan_type AS ENUM ('educativo', 'personal', 'vivienda', 'libre_inversion', 'emergencia');

-- Loan status
CREATE TYPE loan_status AS ENUM ('draft', 'submitted', 'under_review', 'approved', 'rejected', 'active', 'paid_off', 'defaulted');

-- Loans table
CREATE TABLE loans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    
    -- Loan details
    tipo loan_type NOT NULL,
    monto_solicitado DECIMAL(15,2) NOT NULL,
    monto_aprobado DECIMAL(15,2),
    plazo_meses INTEGER NOT NULL,
    tasa_interes_mensual DECIMAL(8,4) NOT NULL,
    cuota_mensual DECIMAL(15,2),
    
    -- Status and dates
    status loan_status NOT NULL DEFAULT 'draft',
    fecha_solicitud TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_aprobacion TIMESTAMP,
    fecha_desembolso TIMESTAMP,
    fecha_primer_pago DATE,
    
    -- Current loan state
    saldo_capital DECIMAL(15,2) DEFAULT 0,
    saldo_interes DECIMAL(15,2) DEFAULT 0,
    cuotas_pagadas INTEGER DEFAULT 0,
    cuotas_en_mora INTEGER DEFAULT 0,
    
    -- Approval workflow
    aprobado_por UUID REFERENCES users(id),
    observaciones TEXT,
    documentos_requeridos JSONB,
    documentos_entregados JSONB,
    
    -- System fields
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id)
);

-- Payment schedules (amortization table)
CREATE TABLE loan_payment_schedule (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    loan_id UUID NOT NULL REFERENCES loans(id) ON DELETE CASCADE,
    
    numero_cuota INTEGER NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    valor_cuota DECIMAL(15,2) NOT NULL,
    capital DECIMAL(15,2) NOT NULL,
    interes DECIMAL(15,2) NOT NULL,
    saldo_pendiente DECIMAL(15,2) NOT NULL,
    
    -- Payment tracking
    pagado BOOLEAN DEFAULT FALSE,
    fecha_pago TIMESTAMP,
    valor_pagado DECIMAL(15,2),
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Loan payments
CREATE TABLE loan_payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    loan_id UUID NOT NULL REFERENCES loans(id),
    schedule_id UUID REFERENCES loan_payment_schedule(id),
    
    valor_pago DECIMAL(15,2) NOT NULL,
    valor_capital DECIMAL(15,2) NOT NULL,
    valor_interes DECIMAL(15,2) NOT NULL,
    valor_mora DECIMAL(15,2) DEFAULT 0,
    
    fecha_pago TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    metodo_pago VARCHAR(50), -- 'nomina', 'transferencia', 'efectivo', etc.
    referencia_pago VARCHAR(100),
    
    -- System fields
    procesado_por UUID REFERENCES users(id),
    observaciones TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- AUXILIOS (AID/ASSISTANCE PROGRAMS)
-- =====================================================

-- Aid types
CREATE TYPE aid_type AS ENUM ('juridico', 'medico', 'educativo', 'calamidad', 'funeral', 'matrimonio', 'nacimiento');

-- Aid status
CREATE TYPE aid_status AS ENUM ('draft', 'submitted', 'under_review', 'approved', 'rejected', 'paid', 'cancelled');

-- Aid requests
CREATE TABLE aid_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    
    -- Request details
    tipo aid_type NOT NULL,
    monto_solicitado DECIMAL(15,2) NOT NULL,
    monto_aprobado DECIMAL(15,2),
    descripcion TEXT NOT NULL,
    justificacion TEXT,
    
    -- Status and workflow
    status aid_status NOT NULL DEFAULT 'draft',
    fecha_solicitud TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_aprobacion TIMESTAMP,
    fecha_pago TIMESTAMP,
    
    -- Documents and approval
    documentos_requeridos JSONB,
    documentos_entregados JSONB,
    aprobado_por UUID REFERENCES users(id),
    observaciones_aprobacion TEXT,
    
    -- System fields
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id)
);

-- =====================================================
-- SAVINGS AND CONTRIBUTIONS
-- =====================================================

-- Account types
CREATE TYPE account_type AS ENUM ('ahorros', 'aportes', 'permanencia');

-- Savings accounts
CREATE TABLE savings_accounts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    
    tipo account_type NOT NULL,
    numero_cuenta VARCHAR(20) UNIQUE NOT NULL,
    saldo_actual DECIMAL(15,2) DEFAULT 0,
    saldo_minimo DECIMAL(15,2) DEFAULT 0,
    
    -- Status
    activa BOOLEAN DEFAULT TRUE,
    fecha_apertura DATE DEFAULT CURRENT_DATE,
    fecha_cierre DATE,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Savings transactions
CREATE TABLE savings_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account_id UUID NOT NULL REFERENCES savings_accounts(id),
    
    tipo_transaccion VARCHAR(20) NOT NULL, -- 'deposito', 'retiro', 'interes'
    valor DECIMAL(15,2) NOT NULL,
    saldo_anterior DECIMAL(15,2) NOT NULL,
    saldo_nuevo DECIMAL(15,2) NOT NULL,
    
    descripcion TEXT,
    referencia VARCHAR(100),
    fecha_transaccion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- System fields
    procesado_por UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- MUTUAL INSURANCE (MUTUOS)
-- =====================================================

-- Mutual types
CREATE TYPE mutual_type AS ENUM ('vida', 'hogar', 'vehiculo', 'salud');

-- Mutual status
CREATE TYPE mutual_status AS ENUM ('active', 'suspended', 'cancelled', 'claim_pending');

-- Mutual policies
CREATE TABLE mutual_policies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    
    tipo mutual_type NOT NULL,
    numero_poliza VARCHAR(30) UNIQUE NOT NULL,
    valor_asegurado DECIMAL(15,2) NOT NULL,
    prima_mensual DECIMAL(15,2) NOT NULL,
    
    status mutual_status NOT NULL DEFAULT 'active',
    fecha_inicio DATE NOT NULL,
    fecha_vencimiento DATE,
    
    -- Beneficiaries (for life insurance)
    beneficiarios JSONB,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Mutual claims
CREATE TABLE mutual_claims (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    policy_id UUID NOT NULL REFERENCES mutual_policies(id),
    
    fecha_siniestro DATE NOT NULL,
    descripcion_siniestro TEXT NOT NULL,
    monto_reclamado DECIMAL(15,2) NOT NULL,
    monto_aprobado DECIMAL(15,2),
    
    status VARCHAR(20) DEFAULT 'submitted', -- 'submitted', 'under_review', 'approved', 'rejected', 'paid'
    
    documentos_soporte JSONB,
    observaciones TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- DOCUMENTS AND FILE MANAGEMENT
-- =====================================================

-- Document types
CREATE TYPE document_type AS ENUM ('cedula', 'certificado_laboral', 'comprobante_ingresos', 'referencias', 'paz_salvo', 'certificado_cuenta', 'estado_cuenta', 'comprobante_pago', 'solicitud', 'contrato');

-- Documents table
CREATE TABLE documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    
    -- Document metadata
    nombre_archivo VARCHAR(255) NOT NULL,
    tipo document_type NOT NULL,
    descripcion TEXT,
    url_archivo VARCHAR(500) NOT NULL,
    tamaño_bytes BIGINT,
    tipo_mime VARCHAR(100),
    
    -- Related entity (loan, aid, etc.)
    entidad_relacionada VARCHAR(50), -- 'loan', 'aid', 'user', etc.
    id_entidad_relacionada UUID,
    
    -- Status and security
    verificado BOOLEAN DEFAULT FALSE,
    verificado_por UUID REFERENCES users(id),
    fecha_verificacion TIMESTAMP,
    
    -- System fields
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id)
);

-- =====================================================
-- NEWS AND COMMUNICATIONS
-- =====================================================

-- News categories
CREATE TYPE news_category AS ENUM ('convocatoria', 'asamblea', 'evento', 'comunicado', 'noticia');

-- News and announcements
CREATE TABLE news (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    titulo VARCHAR(255) NOT NULL,
    resumen TEXT,
    contenido TEXT NOT NULL,
    categoria news_category NOT NULL,
    
    -- Publishing
    publicado BOOLEAN DEFAULT FALSE,
    fecha_publicacion TIMESTAMP,
    fecha_expiracion TIMESTAMP,
    
    -- Media
    imagen_principal VARCHAR(500),
    adjuntos JSONB,
    
    -- SEO and organization
    slug VARCHAR(255) UNIQUE,
    tags TEXT[],
    
    -- System fields
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID NOT NULL REFERENCES users(id),
    updated_by UUID REFERENCES users(id)
);

-- =====================================================
-- AUDIT AND LOGGING
-- =====================================================

-- System audit log
CREATE TABLE audit_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Who and when
    user_id UUID REFERENCES users(id),
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50) NOT NULL, -- 'user', 'loan', 'aid', etc.
    entity_id UUID NOT NULL,
    
    -- What changed
    old_values JSONB,
    new_values JSONB,
    
    -- Context
    ip_address INET,
    user_agent TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- SYSTEM CONFIGURATION
-- =====================================================

-- System settings and parameters
CREATE TABLE system_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    clave VARCHAR(100) UNIQUE NOT NULL,
    valor TEXT NOT NULL,
    descripcion TEXT,
    tipo_dato VARCHAR(20) DEFAULT 'string', -- 'string', 'number', 'boolean', 'json'
    
    -- Access control
    publico BOOLEAN DEFAULT FALSE,
    modificable BOOLEAN DEFAULT TRUE,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by UUID REFERENCES users(id)
);

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- Users indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_cedula ON users(cedula);
CREATE INDEX idx_users_numero_asociado ON users(numero_asociado);
CREATE INDEX idx_users_role_status ON users(role, status);

-- Loans indexes
CREATE INDEX idx_loans_user_id ON loans(user_id);
CREATE INDEX idx_loans_status ON loans(status);
CREATE INDEX idx_loans_tipo ON loans(tipo);
CREATE INDEX idx_loans_fecha_solicitud ON loans(fecha_solicitud);

-- Payments indexes
CREATE INDEX idx_loan_payments_loan_id ON loan_payments(loan_id);
CREATE INDEX idx_loan_payments_fecha ON loan_payments(fecha_pago);
CREATE INDEX idx_payment_schedule_loan_id ON loan_payment_schedule(loan_id);
CREATE INDEX idx_payment_schedule_vencimiento ON loan_payment_schedule(fecha_vencimiento);

-- Aid requests indexes
CREATE INDEX idx_aid_requests_user_id ON aid_requests(user_id);
CREATE INDEX idx_aid_requests_status ON aid_requests(status);
CREATE INDEX idx_aid_requests_tipo ON aid_requests(tipo);

-- Savings indexes
CREATE INDEX idx_savings_accounts_user_id ON savings_accounts(user_id);
CREATE INDEX idx_savings_transactions_account_id ON savings_transactions(account_id);
CREATE INDEX idx_savings_transactions_fecha ON savings_transactions(fecha_transaccion);

-- Documents indexes
CREATE INDEX idx_documents_user_id ON documents(user_id);
CREATE INDEX idx_documents_tipo ON documents(tipo);
CREATE INDEX idx_documents_entidad ON documents(entidad_relacionada, id_entidad_relacionada);

-- Audit indexes
CREATE INDEX idx_audit_log_user_id ON audit_log(user_id);
CREATE INDEX idx_audit_log_entity ON audit_log(entity_type, entity_id);
CREATE INDEX idx_audit_log_created_at ON audit_log(created_at);

-- =====================================================
-- DEFAULT DATA AND CONFIGURATION
-- =====================================================

-- Insert default system settings
INSERT INTO system_settings (clave, valor, descripcion, tipo_dato, publico) VALUES
('cooperativa_nombre', 'COOGUARPENAL Ltda.', 'Nombre oficial de la cooperativa', 'string', true),
('cooperativa_nit', '123456789-0', 'NIT de la cooperativa', 'string', true),
('cooperativa_direccion', 'Carrera XX #XX-XX, Bogotá D.C.', 'Dirección principal', 'string', true),
('cooperativa_telefono', '(601) XXX-XXXX', 'Teléfono principal', 'string', true),
('cooperativa_email', 'info@cooguardpenal.com', 'Email institucional', 'string', true),

-- Interest rates
('tasa_credito_educativo', '0.008', 'Tasa mensual para créditos educativos', 'number', false),
('tasa_credito_personal', '0.012', 'Tasa mensual para créditos personales', 'number', false),
('tasa_credito_vivienda', '0.009', 'Tasa mensual para créditos de vivienda', 'number', false),

-- Loan limits
('monto_maximo_educativo', '5000000', 'Monto máximo para créditos educativos', 'number', false),
('monto_maximo_personal', '3000000', 'Monto máximo para créditos personales', 'number', false),
('plazo_maximo_educativo', '36', 'Plazo máximo en meses para créditos educativos', 'number', false),
('plazo_maximo_personal', '24', 'Plazo máximo en meses para créditos personales', 'number', false),

-- Aid amounts
('auxilio_juridico_maximo', '500000', 'Monto máximo para auxilio jurídico', 'number', false),
('auxilio_medico_maximo', '300000', 'Monto máximo para auxilio médico', 'number', false),
('auxilio_calamidad_maximo', '1000000', 'Monto máximo para auxilio por calamidad', 'number', false),

-- System configuration
('descuento_nomina_maximo', '30', 'Porcentaje máximo de descuento por nómina', 'number', false),
('archivo_tamaño_maximo', '10485760', 'Tamaño máximo de archivo en bytes (10MB)', 'number', false),
('session_timeout', '3600', 'Tiempo de expiración de sesión en segundos', 'number', false);

-- =====================================================
-- TRIGGERS FOR AUTOMATIC UPDATES
-- =====================================================

-- Update timestamp trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply timestamp triggers to relevant tables
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_loans_updated_at BEFORE UPDATE ON loans
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_aid_requests_updated_at BEFORE UPDATE ON aid_requests
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_savings_accounts_updated_at BEFORE UPDATE ON savings_accounts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_mutual_policies_updated_at BEFORE UPDATE ON mutual_policies
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_news_updated_at BEFORE UPDATE ON news
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_system_settings_updated_at BEFORE UPDATE ON system_settings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- VIEWS FOR COMMON QUERIES
-- =====================================================

-- View for user loan summary
CREATE VIEW v_user_loan_summary AS
SELECT 
    u.id as user_id,
    u.nombres,
    u.apellidos,
    u.numero_asociado,
    COUNT(l.id) as total_loans,
    COUNT(CASE WHEN l.status = 'active' THEN 1 END) as active_loans,
    COALESCE(SUM(CASE WHEN l.status = 'active' THEN l.saldo_capital END), 0) as total_outstanding,
    COALESCE(SUM(CASE WHEN l.status = 'active' THEN l.cuota_mensual END), 0) as total_monthly_payment
FROM users u
LEFT JOIN loans l ON u.id = l.user_id
WHERE u.role = 'member'
GROUP BY u.id, u.nombres, u.apellidos, u.numero_asociado;

-- View for payment calendar
CREATE VIEW v_payment_calendar AS
SELECT 
    lps.id,
    lps.loan_id,
    l.user_id,
    u.nombres || ' ' || u.apellidos as user_name,
    u.numero_asociado,
    l.tipo as loan_type,
    lps.numero_cuota,
    lps.fecha_vencimiento,
    lps.valor_cuota,
    lps.pagado,
    lps.fecha_pago,
    CASE 
        WHEN lps.pagado THEN 'paid'
        WHEN lps.fecha_vencimiento < CURRENT_DATE THEN 'overdue'
        WHEN lps.fecha_vencimiento <= CURRENT_DATE + INTERVAL '7 days' THEN 'due_soon'
        ELSE 'future'
    END as payment_status
FROM loan_payment_schedule lps
JOIN loans l ON lps.loan_id = l.id
JOIN users u ON l.user_id = u.id
WHERE l.status = 'active'
ORDER BY lps.fecha_vencimiento;

-- View for financial dashboard
CREATE VIEW v_financial_dashboard AS
SELECT 
    'summary' as metric_type,
    COUNT(DISTINCT u.id) as total_members,
    COUNT(DISTINCT CASE WHEN l.status = 'active' THEN l.id END) as active_loans,
    COALESCE(SUM(CASE WHEN l.status = 'active' THEN l.saldo_capital END), 0) as total_outstanding,
    COALESCE(SUM(sa.saldo_actual), 0) as total_savings,
    COUNT(DISTINCT CASE WHEN mp.status = 'active' THEN mp.id END) as active_policies
FROM users u
LEFT JOIN loans l ON u.id = l.user_id
LEFT JOIN savings_accounts sa ON u.id = sa.user_id AND sa.activa = true
LEFT JOIN mutual_policies mp ON u.id = mp.user_id
WHERE u.role = 'member';

-- =====================================================
-- SECURITY POLICIES (RLS - Row Level Security)
-- =====================================================

-- Enable RLS on sensitive tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE loans ENABLE ROW LEVEL SECURITY;
ALTER TABLE aid_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE savings_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;

-- Example policy: Users can only see their own data
CREATE POLICY user_own_data ON users
    FOR SELECT
    USING (id = current_setting('app.current_user_id')::UUID OR 
           current_setting('app.current_user_role') IN ('admin', 'manager'));

-- Example policy: Loans visibility
CREATE POLICY loan_access ON loans
    FOR SELECT
    USING (user_id = current_setting('app.current_user_id')::UUID OR 
           current_setting('app.current_user_role') IN ('admin', 'manager'));

-- =====================================================
-- COMMENTS FOR DOCUMENTATION
-- =====================================================

COMMENT ON TABLE users IS 'Tabla principal de usuarios del sistema (asociados y personal administrativo)';
COMMENT ON TABLE loans IS 'Registro de todos los préstamos solicitados y otorgados';
COMMENT ON TABLE aid_requests IS 'Solicitudes de auxilios de los asociados';
COMMENT ON TABLE savings_accounts IS 'Cuentas de ahorro y aportes de los asociados';
COMMENT ON TABLE mutual_policies IS 'Pólizas de seguros mutuos';
COMMENT ON TABLE documents IS 'Gestión de documentos digitales del sistema';
COMMENT ON TABLE audit_log IS 'Registro de auditoría de todas las acciones del sistema';

-- =====================================================
-- SAMPLE DATA FOR TESTING (Optional)
-- =====================================================

-- Create a default admin user (password should be changed immediately)
-- INSERT INTO users (
--     email, password_hash, role, status, cedula, nombres, apellidos,
--     numero_asociado, fecha_ingreso_cooperativa
-- ) VALUES (
--     'admin@cooguardpenal.com', 
--     '$2b$10$example_hash', -- This should be a proper bcrypt hash
--     'admin', 
--     'active',
--     '12345678',
--     'Administrador',
--     'Sistema',
--     'ADM001',
--     CURRENT_DATE
-- );

-- =====================================================
-- END OF SCHEMA
-- =====================================================
