# BMX Race Tracker - Database Schema Proposal

## Overview
This document outlines the proposed database schema for the BMX Race Tracker application.

## Tables

### 1. Users
Stores authenticated users who can manage races (operators, admins, super_admins).

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| id | integer | Primary key | NOT NULL, AUTO_INCREMENT |
| email | string | User email for login | NOT NULL, UNIQUE |
| encrypted_password | string | Devise encrypted password | NOT NULL |
| role | string | User role: operator, admin, super_admin | NOT NULL, DEFAULT: 'operator' |
| club_id | integer | Foreign key to clubs | NULL (super_admin has no club) |
| name | string | User's display name | NOT NULL |
| created_at | datetime | | NOT NULL |
| updated_at | datetime | | NOT NULL |

**Indexes:**
- email (unique)
- club_id

### 2. Clubs
Represents BMX clubs that have their own race tracker.

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| id | integer | Primary key | NOT NULL, AUTO_INCREMENT |
| name | string | Club display name | NOT NULL |
| slug | string | URL-friendly identifier | NOT NULL, UNIQUE |
| active | boolean | Whether club is active | NOT NULL, DEFAULT: true |
| created_at | datetime | | NOT NULL |
| updated_at | datetime | | NOT NULL |

**Indexes:**
- slug (unique)
- active

### 3. Races
Stores the current race state for each club. One active race per club at a time.

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| id | integer | Primary key | NOT NULL, AUTO_INCREMENT |
| club_id | integer | Foreign key to clubs | NOT NULL |
| gate_counter | integer | Current moto at gate | NOT NULL, DEFAULT: 0 |
| staging_counter | integer | Current moto in staging | NOT NULL, DEFAULT: 1 |
| registration_deadline | time | Registration closes at | NULL |
| race_start_time | time | Race starts at | NULL |
| active | boolean | Is this the active race | NOT NULL, DEFAULT: true |
| race_date | date | Date of the race | NOT NULL, DEFAULT: current_date |
| created_at | datetime | | NOT NULL |
| updated_at | datetime | | NOT NULL |

**Indexes:**
- club_id, active (composite - ensures one active race per club)
- race_date

## Key Design Decisions

1. **Users Table:**
   - No "viewer" role needed since viewing is public
   - club_id is nullable to support super_admins who aren't tied to a club
   - Using string enum for roles for simplicity

2. **Clubs Table:**
   - `slug` field for URL routing (/airdriebmx)
   - `active` flag to disable clubs without deleting data

3. **Races Table:**
   - One race record per race day per club
   - `active` flag to maintain history while having current race
   - Separate time fields (not datetime) since races happen on specific days
   - Counter validation will happen at application level

## Questions for Consideration

1. Should we track race history or just current state?
2. Do we need to store operator actions (audit log)?
3. Should registration_deadline and race_start_time be stored differently?
4. Do clubs need additional configuration fields?
5. Should we add a "notes" or "announcement" field to races?

## Migration Order
1. Create clubs table
2. Create users table (with club_id foreign key)
3. Create races table (with club_id foreign key)

Please review and let me know if you'd like any changes to this schema.