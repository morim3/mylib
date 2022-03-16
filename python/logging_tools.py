# modifie slightly from https://github.com/jaywalnut310/glow-tts/blob/master/LICENSE

import glob
import logging
import sys
import os
import torch

logging.basicConfig(stream=sys.stdout, level=logging.INFO)
logger = logging


def get_logger(model_dir, filename="train.log"):
    global logger
    logger = logging.getLogger(os.path.basename(model_dir))
    logger.setLevel(logging.DEBUG)

    formatter = logging.Formatter("%(asctime)s\t%(name)s\t%(levelname)s\t%(message)s")
    if not os.path.exists(model_dir):
        os.makedirs(model_dir)
    h = logging.FileHandler(os.path.join(model_dir, filename))
    h.setLevel(logging.DEBUG)
    h.setFormatter(formatter)
    logger.addHandler(h)
    return logger


def save_checkpoint(model, optimizer, learning_rate, iteration, fold, checkpoint_path):
    logger.info("Saving model and optimizer state at iteration {} in fold {} to {}".format(
        iteration, fold, checkpoint_path))
    if hasattr(model, 'module'):
        state_dict = model.module.state_dict()
    else:
        state_dict = model.state_dict()
    torch.save({'model': state_dict,
                'iteration': iteration,
                'fold': fold,
                'optimizer': optimizer.state_dict(),
                'learning_rate': learning_rate}, checkpoint_path)


def summarize(writer, fold, global_step, scalars={}, histograms={}, images={}, figures={}):
    if len(scalars):
        writer.add_scalars('runs_split{}'.format(fold), scalars, global_step)
    for k, v in histograms.items():
        writer.add_histogram('runs_split{} {}'.format(fold, k), v, global_step)
    for k, v in images.items():
        writer.add_image('runs_split{} {}'.format(fold, k), v, global_step, dataformats='HWC')
    for k, v in figures.items():
        writer.add_figure('runs_split{} {}'.format(fold, k), v, global_step)


def latest_checkpoint_path(dir_path, regex="model_*.pth"):
    f_list = glob.glob(os.path.join(dir_path, regex))
    f_list.sort(key=lambda f: int("".join(filter(str.isdigit, f))))
    x = f_list[-1]
    print(x)
    return x


def load_checkpoint(checkpoint_path, model, optimizer=None):
    assert os.path.isfile(checkpoint_path)
    checkpoint_dict = torch.load(checkpoint_path, map_location='cpu')
    iteration = checkpoint_dict['iteration']
    learning_rate = checkpoint_dict['learning_rate']
    if optimizer is not None:
        optimizer.load_state_dict(checkpoint_dict['optimizer'])
    saved_state_dict = checkpoint_dict['model']
    if hasattr(model, 'module'):
        state_dict = model.module.state_dict()
    else:
        state_dict = model.state_dict()
    new_state_dict = {}
    for k, v in state_dict.items():
        try:
            new_state_dict[k] = saved_state_dict[k]
        except:
            logger.info("%s is not in the checkpoint" % k)
            new_state_dict[k] = v
    if hasattr(model, 'module'):
        model.module.load_state_dict(new_state_dict)
    else:
        model.load_state_dict(new_state_dict)
    logger.info("Loaded checkpoint '{}' (iteration {})".format(
        checkpoint_path, iteration))
    return model, optimizer, learning_rate, iteration

