# Ansible Redmine Role + Molecule Testing + Vagrant

Se ha construido un rol de Ansible que se encarga de instalar MariaDB (motor de base de datos), Nginx (servidor web HTTP), Puma (servidor de aplicacion Ruby) y finalmente instala Redmine (sistemas gestor de Tickets). Para utilizar este rol se ha planteado utilizar Vagrant para crear el entorno de desarrollo con VBox como driver. De esta forma, el entorno es aprovisionado con el playbook que implementa el rol descrito. Para las pruebas se utiliza Molecule, el cual se encarga de crear con Vagrant las maquinas virtuales donde se ejecutara el playbook y luego se hace una pequeña comprobacion de los servicios con TestInfra. Las pruebas realizadas se hacen con Ubuntu 20.04 y Ubuntu 18.04.

## Instalacion y guia de uso

Antes de comenzar es importante activar la virtualizacion desde la BIOS (AMD-V o Intel VT).

### Utilizar el despliegue en Vangrant

Si se quiere levantar el entorno con Vagrant se debe clonar el repositorio e ingresar a la carpeta.

```
git clone https://github.com/manuelchichi/ansible-redmine-role
cd ansible-redmine-role/
```

Luego para instalar el sistema propuesto se debe contar con los siguientes paquetes:

Vagrant (2.2.14) [DESCARGA](https://www.vagrantup.com/downloads.html)

En ubuntu 18.04 o 20.04:
```
sudo apt-get install vagrant
```

Virtualbox (6.1.16) [DESCARGA](https://www.virtualbox.org/wiki/Downloads)

En ubuntu 18.04 o 20.04:
```
sudo apt-get install virtualbox
```

Ansible (2.9.6) [DESCARGA](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

En ubuntu 18.04 o 20.04:
```
sudo apt-get install ansible 
```

En Ansible debemos instalar los siguientes paquetes.
```
ansible-galaxy collection install community.mysql
ansible-galaxy collection install community.general
```

Una vez que tenemos todo lo instalado debemos inicializar la maquina virtual con Vagrant.
```
vagrant up
```

Esto levantara la maquina virtual (ubuntu 20.04) y la aprovisionara con el rol de redmine.

Una vez finalizados estos pasos se podra acceder en la siguiente direccion localhost:8082 (el puerto puede cambiar segun el Vagrantfile). Las credenciales del usuario por defecto son usuario: admin y contraseña: admin.

### Entorno de pruebas.

Para inicializar el entorno de pruebas, ademas de los paquetes mencionados en la seccion anterior se deben de contar con los siguientes paquetes.

Python con PIP3 y venv (3.8.5) [DESCARGA](https://www.python.org/downloads/)

En ubuntu 18.04 o 20.04:
```
sudo apt-get install python3 python3-pip python3-venv
```

En cuanto a las librerias Python necesarias se deben ejecutar los siguientes comandos dentro de la carpeta raiz del proyecto.
```
python3 -m venv env
source env/bin/activate
pip3 install -r requeriments.txt
```

Una vez inicializado el entorno en Python nos debemos dirigir la carpeta que contiene el rol (roles/redmine/). Alli se debe ejecutar el siguiente comando para realizar el set de pruebas completo y luego borrar las instancias.
```
cd roles/redmine/
molecule test
```

Si se desea crear las instancias y correr los playbooks sin realizar las pruebas ni destruir las instancias.
```
molecule converge
```

Luego sobre este podremos realizar la verificacion con el siguiente comando.
```
molecule verify
```

## Variables de entorno

Se han agregado una serie de variables de entorno para personalizar la instalacion de Redmine segun se desee. Se lista a continuacion algunas de ellas.

+ redmine_version: (Version de redmine)
+ redmine_user_password: (Contraseña del usuario Redmine de la base de datos)
+ mariadb_root_password: (Contraseña del usuario Root de la base de datos)
+ ruby_version: (Indica la version de Ruby que se instalara)

## Mejoras

- [X] Utilizar RVM para manejar las versiones de Ruby.
- [X] Cambiar a Nginx + Puma.
- [X] Hacer mas controles con las versiones de Ubuntu.
- [X] Indicar correctamenta las dependencias.
- [X] Agregar documentacion de Variables de entorno en el README.
- [X] Agregar mas variables al rol Redmine.
- [ ] Mejorar la instalacion de RVM y la forma de invocarlo.
- [ ] Mejorar pruebas con constantes fijas (puerto) en el test_redmine.py .
- [ ] Analizar la posibilidad de separar en roles.

