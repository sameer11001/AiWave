""" Built-in modules """
import sys

""" Third-party modules """
import torch

class ServerInfoChecker:
    """
    A class to check system information including Python version, CUDA version, and GPU model using PyTorch.
    """

    @staticmethod
    def get_python_version() -> str:
        """
        Get the Python version.

        Returns:
            str: Python version string.
        """
        return f"Python Version: {sys.version.split()[0]} 🐍"

    @staticmethod
    def get_cuda_version() -> str:
        """
        Get the CUDA version.

        Returns:
            str: CUDA version string.
        """
        if torch.cuda.is_available():
            cuda_version = torch.version.cuda
            return f"CUDA Version: {cuda_version} 🚀"
        else:
            return "CUDA Version: Not Found ❌"

    @staticmethod
    def get_gpu_model() -> str:
        """
        Get the GPU model.

        Returns:
            str: GPU model string.
        """
        if torch.cuda.is_available():
            gpu_model = torch.cuda.get_device_name(0)
            return f"GPU Model: {gpu_model} 💻"
        else:
            return "GPU Model: Not Found ❌"

    @staticmethod
    def print_system_info_card() -> None:
        """
        Print system information as a card.

        Returns:
            None
        """
        python_version = ServerInfoChecker.get_python_version()
        cuda_version = ServerInfoChecker.get_cuda_version()
        gpu_model = ServerInfoChecker.get_gpu_model()

        card_template = (
            "+----------------------+\n"
            "|      System Info     |\n"
            "+----------------------+\n"
            f"{python_version}\n{cuda_version}\n{gpu_model}\n"
            "+----------------------+"
        )

        print(card_template)

# Usage
if __name__ == "__main__":
    ServerInfoChecker.print_system_info_card()
