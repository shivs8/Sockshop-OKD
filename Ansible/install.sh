#/bin/sh
yum install ansible*
#need to work on ansible rpm
curl -o ansible-tower-setup-latest.tar.gz http://releases.ansible.com/ansible-tower/setup/ansible-tower-setup-latest.tar.gz
down=$(ls -ltr | grep -i ansible| awk '{print $9}')
tar -xvf $down
file=$(ls -ltr | grep -i ansible| grep -v latest| awk '{print $9}')
echo $file
cd  $file
cp -rp inventory inventory_bkp
sed 's/admin_password/#admin_password/g' inventory_bkp | sed 's/pg_password/#pg_password/g' > inventory
echo "admin_password='dynatrace'" >> inventory
echo "pg_password='ansible'" >> inventory
ANSIBLE_SUDO=True ./setup.sh


