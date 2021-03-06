from execo_engine import Engine, logger
from execo_g5k import oarsub, OarSubmission, oardel, wait_oar_job_start, get_oar_job_nodes, Deployment, deploy
from execo import Put, Remote, Process
import sys

def create_subdir(base_dir, sub_dir):
    dir_path="{}/{}".format(base_dir, sub_dir)
    mkdir_cmd="mkdir -p {}".format(dir_path)
    Process(mkdir_cmd).run()
    return dir_path
    

def deploy_node(job_id, site, submission):
    node = get_oar_job_nodes(job_id,site)[0]
    deployment = Deployment(hosts = [node],
                    env_file = "unikernels/hermit/debian10-x64-nfs-hermit.env",
                    user = "root",
                    other_options = "-k")
    node.user = "root"
    deploy(deployment)
    return node

def setup_node(node):
    clone_bench = Remote('git clone https://github.com/p-jacquot/unikernel-tools', node).run()
    return clone_bench.ok 

def run_bench(output_folder, node):
    debian_bench_command = "./benchs.sh {} 10 \"1 2 4 8 16\"".format(debian_folder)
    debian_bench = Remote('cd ./unikernel-tools/benchs/rodinias && {}'.format(debian_bench_command), node).run()

def launch_bench(oarsubmission, site, folder):
        """Copy required files on frontend(s) and compile bench suite."""
        logger.info("Reserving a node.")
        jobs = oarsub([(oarsubmission, site)])
        (job_id, site) = jobs[0]
        logger.info(jobs)
        if job_id:
            try:
                logger.info("Node reserved.")
                wait_oar_job_start(job_id, site)
                logger.info("Deploying environment.")
                node = deploy_node(job_id, site, oarsubmission)
                logger.info("Cloning repo.")
                setup_node(node)
                logger.info("Starting Rodinias benchs.")
                run_bench(folder, node)
            except:
                logger.error("Unable to run Benchs.")
                oardel(jobs)
                return False
        logger.info("Benchs completed. Deleting jobs.")
        oardel(jobs)
        return True

if __name__ == "__main__":
    args = sys.argv[1:]
    prop = args[0]
    site = args[1]
    folder = args[2]
    
    if len(args) >= 5:
        date = args[3]
        walltime = args[4]
        submission = OarSubmission(resources = "nodes=1",
                job_type = 'deploy',
                walltime = walltime,
                reservation_date = date,
                sql_properties = prop)
        launch_bench(submission, site, folder)
    else:
        walltime = args[3]
        submission = OarSubmission(resources = "nodes=1",
                job_type = 'deploy',
                walltime = walltime,
                sql_properties = prop)
        launch_bench(submission, site, folder)

