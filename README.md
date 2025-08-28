# DBT Oracle Project

This repository contains a dbt project configured to work with Oracle databases.

## Cross-Platform Setup Instructions

This project is designed to work across different operating systems (Windows, macOS) while maintaining consistent behavior.

### First-Time Setup

1. Clone this repository:
   ```
   git clone https://github.com/vmanchik/dbt-oracle-project.git
   cd dbt-oracle-project
   ```

2. Create local environment configuration:
   - **For Windows**:
     ```
     copy env_setup.bat.template env_setup.bat
     copy .dbt\profiles.yml.template .dbt\profiles.yml
     ```
   - **For macOS/Linux**:
     ```
     cp env_setup.sh.template env_setup.sh
     cp .dbt/profiles.yml.template .dbt/profiles.yml
     chmod +x env_setup.sh
     ```

3. Edit the copied files with your specific environment settings:
   - Update connection credentials in `.dbt/profiles.yml`
   - Set your Oracle password and paths in `env_setup.sh` or `env_setup.bat`

4. Set up Oracle Instant Client:
   - **For Windows**: Install at `C:\Oracle\instantclient_19_3\` or update path in env_setup.bat
   - **For macOS**: Install and update path in env_setup.sh

5. Activate your environment:
   - **For Windows**: Run `env_setup.bat` in your terminal
   - **For macOS/Linux**: Run `source env_setup.sh` in your terminal

### Using the SQL Runner

For Oracle thick mode connections, use the included `run_sql.py` script:

```
python run_sql.py your_query.sql --format csv --out results.csv
```

### Using DBT

Run dbt commands from the oracle_project directory:

```
cd oracle_project
dbt run --profiles-dir ../.dbt
```

### Working with Multiple Systems

1. **DO NOT** commit your local configuration files to Git
2. Make sure each system has its own local configuration
3. Keep code changes separate from environment-specific settings

## Project Structure

- `oracle_project/` - The main dbt project directory
- `.dbt/` - Contains profiles.yml and other dbt configuration
- `local_config/` - Directory for local configuration files (not tracked by Git)
- `*.template` files - Templates for local configuration files

## Environment-Specific Files (not tracked by Git)

- `.dbt/profiles.yml` - Database connection profiles
- `env_setup.sh` / `env_setup.bat` - Environment setup scripts
- `local_config/*` - Local configuration files
