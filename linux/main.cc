#include "adb_manager.h"

int main(int argc, char** argv) {
  g_autoptr(AdbManager) app = adb_manager_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
