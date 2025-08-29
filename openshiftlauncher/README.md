# OpenShift Project Launcher - Complete Setup Guide

## 📁 Files Created

I've created a complete OpenShift project launcher system with the following files:

### **Core Files**
1. **openshift-launcher.bat** - Main launcher script (reads plain text credentials)
2. **openshift_projects.txt** - Project configuration file  
3. **credentials.txt** - Username/password file (plain text)

### **Security Enhanced Files**
4. **openshift-launcher-secure.bat** - Secure launcher (uses encoded passwords)
5. **credentials_encoded.txt** - Base64 encoded credentials file

### **Utility Files**
6. **encode_password.bat** - Password encoder utility
7. **create_credentials.bat** - Interactive credential file creator

## 🚀 Quick Start Guide

### **Step 1: Customize Your Projects**
Edit `openshift_projects.txt` to match your actual OpenShift projects:
```text
your-app|DEV|https://your-cluster.com/console/project/your-app-dev
your-app|QA|https://your-cluster.com/console/project/your-app-qa
your-app|PROD|https://your-cluster.com/console/project/your-app-prod
```

### **Step 2: Set Up Your Credentials**

#### **Option A: Plain Text (Quick Setup)**
Edit `credentials.txt`:
```text
your-cluster.com|your-username|your-password
another-cluster.com|your-username|different-password
```

#### **Option B: Interactive Setup**
Run `create_credentials.bat` to create credentials interactively:
- Prompts for server, username, password
- Creates the credentials file automatically
- Shows current contents

#### **Option C: Secure Setup (Recommended)**
1. Run `encode_password.bat` to encode your passwords
2. Edit `credentials_encoded.txt` with encoded passwords
3. Use `openshift-launcher-secure.bat` for launches

### **Step 3: Run the Launcher**
```cmd
REM Basic launcher
openshift-launcher.bat

REM Secure launcher (with encoded passwords)
openshift-launcher-secure.bat
```

## 🎯 How It Works

### **File Format Examples**

#### **Projects File Format**
```text
app_name|environment|full_openshift_console_url
```

#### **Credentials File Format**
```text
server_hostname|username|password
```

### **The Process**
1. **Script reads** both configuration files
2. **Displays menu** of available projects
3. **User selects** a project by number
4. **Script extracts** server hostname from project URL
5. **Looks up credentials** for that server
6. **Authenticates** using OpenShift CLI (`oc login`)
7. **Launches browser** to the specific project URL
8. **User is automatically logged in**

## 🔧 Configuration Examples

### **Real-World Projects File**
```text
# Development Environment
user-api|DEV|https://console-openshift-console.apps.dev-cluster.company.com/k8s/ns/team-user-api-dev
order-service|DEV|https://console-openshift-console.apps.dev-cluster.company.com/k8s/ns/team-order-service-dev
payment-gateway|DEV|https://console-openshift-console.apps.dev-cluster.company.com/k8s/ns/team-payment-dev

# QA Environment  
user-api|QA|https://console-openshift-console.apps.qa-cluster.company.com/k8s/ns/team-user-api-qa
order-service|QA|https://console-openshift-console.apps.qa-cluster.company.com/k8s/ns/team-order-service-qa

# Production Environment
user-api|PROD|https://console-openshift-console.apps.prod-cluster.company.com/k8s/ns/team-user-api-prod
order-service|PROD|https://console-openshift-console.apps.prod-cluster.company.com/k8s/ns/team-order-service-prod
```

### **Real-World Credentials File**
```text
# Development cluster credentials
console-openshift-console.apps.dev-cluster.company.com|dev-service-account|dev-password123

# QA cluster credentials  
console-openshift-console.apps.qa-cluster.company.com|qa-service-account|qa-password456

# Production cluster credentials (read-only account)
console-openshift-console.apps.prod-cluster.company.com|prod-readonly|prod-password789
```

## 🎨 Features

### **Smart Credential Matching**
- **Exact hostname matching** first
- **Partial matching** as fallback
- **Manual override** when credentials not found
- **Clear error messages** with helpful suggestions

### **User Experience**
- **ASCII art header** for professional look
- **Formatted table display** of projects
- **Input validation** prevents errors
- **Multiple projects** can be opened in same session
- **Graceful error handling** with recovery options

### **Security Options**
- **Plain text credentials** for quick setup
- **Base64 encoded passwords** for better security
- **No credential caching** - fresh authentication each time
- **Separate credential storage** from project configuration

## 🛠️ Prerequisites

### **Required Software**
1. **OpenShift CLI (`oc`)** - Download from your OpenShift cluster
2. **Windows Command Prompt** or **PowerShell**
3. **Network access** to your OpenShift clusters

### **OpenShift CLI Installation**
```cmd
REM Check if already installed
oc version

REM If not installed, download from:
REM https://docs.openshift.com/container-platform/latest/cli_reference/openshift_cli/getting-started-cli.html
```

## 💡 Usage Tips

### **For Development Teams**
- **Share the project file** across your team
- **Keep individual credentials** separate per user
- **Use environment-specific service accounts** when possible
- **Set up different project files** for different teams/applications

### **For System Administrators**
- **Use service accounts** instead of personal accounts for automation
- **Set appropriate permissions** for each environment
- **Consider using tokens** instead of passwords for better security
- **Implement credential rotation** policies

### **For Security**
- **Use the secure launcher** with encoded passwords
- **Keep credential files** in secure locations
- **Don't commit credentials** to version control
- **Use different passwords** for each environment
- **Consider implementing** MFA where possible

## 🚨 Troubleshooting

### **Common Issues**

#### **"oc command not found"**
- Install OpenShift CLI and add to PATH
- Restart command prompt after installation
- Test with `oc version`

#### **"Authentication failed"**
- Check username/password in credentials file
- Verify server hostname matches project URL
- Test manual login: `oc login https://your-server.com`
- Check network connectivity to cluster

#### **"No credentials found"**
- Verify server hostname in credentials file matches project URL
- Use exact hostname from project URL
- Check for typos in server names
- Try manual credential entry option

#### **"Browser opens but not authenticated"**
- CLI authentication may have failed silently
- Try manual `oc login` first
- Check if session cookies are enabled
- Verify project URL format is correct

### **Debug Mode**
Add this to the top of any script for debugging:
```cmd
echo on
REM Your script content here
pause
```

## 🔄 Maintenance

### **Regular Tasks**
- **Update project URLs** when they change
- **Rotate passwords** periodically  
- **Clean up old projects** no longer needed
- **Update OpenShift CLI** to latest version
- **Test authentication** after password changes

### **Adding New Projects**
1. Add line to `openshift_projects.txt`:
   ```text
   new-app|STAGING|https://cluster.com/console/project/new-app-staging
   ```
2. Add credentials if new server:
   ```text
   cluster.com|username|password
   ```
3. Test with launcher

### **Backup Strategy**
- **Backup configuration files** regularly
- **Store credentials securely** (not in version control)
- **Document server URLs** and access requirements
- **Keep launcher scripts** updated

## 🎉 Advanced Usage

### **Team Deployment**
1. **Create shared project file** for team applications
2. **Each user maintains** their own credentials file
3. **Distribute launcher scripts** via shared drive
4. **Maintain documentation** for new team members

### **CI/CD Integration**
- Use these scripts in **build pipelines** for deployment verification
- Integrate with **Jenkins** for automated testing
- Use **service accounts** for automated access
- Generate **dynamic project lists** from cluster APIs

### **Multi-Environment Management**
- **Separate project files** per environment
- **Environment-specific launchers** with different configs
- **Automated environment promotion** workflows
- **Cross-environment comparison** tools

## 📞 Support

### **Getting Help**
1. **Check this documentation** first
2. **Verify prerequisites** are met  
3. **Test individual components** (oc CLI, credentials, network)
4. **Use debug mode** to trace issues
5. **Check OpenShift cluster** status and accessibility

### **Extending the Scripts**
The scripts are designed to be easily customizable:
- **Modify display formatting** in the menu sections
- **Add new authentication methods** (tokens, certificates)
- **Integrate with other tools** (VS Code, monitoring dashboards)
- **Add logging and audit trails** for usage tracking

## 📋 File Structure Summary

After setup, your directory should look like:
```
your-folder/
├── openshift-launcher.bat              # Main launcher (plain credentials)
├── openshift-launcher-secure.bat       # Secure launcher (encoded credentials)  
├── openshift_projects.txt              # Project configurations
├── credentials.txt                     # Plain text credentials
├── credentials_encoded.txt             # Base64 encoded credentials
├── create_credentials.bat              # Interactive credential setup
├── encode_password.bat                 # Password encoder utility
└── README.md                          # This documentation
```

## 🎯 Next Steps

1. **Copy files** to your Windows machine
2. **Edit configuration files** with your actual OpenShift details
3. **Test the basic launcher** with your credentials
4. **Try the secure version** with encoded passwords
5. **Share with your team** and customize as needed

The system is now ready for production use! 🚀
