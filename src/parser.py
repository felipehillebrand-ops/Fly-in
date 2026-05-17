import re
from src.zone import Zone, ZoneType
from src.connection import Connection
from src.graph import Graph


class Parser:
    """Parses the input map file and builds a Graph object."""
    